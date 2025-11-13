<?php
require_once __DIR__ . '/../src/db.php';
require_once __DIR__ . '/../lib/JWT.php';
require_once __DIR__ . '/../lib/Key.php';

class AuthController {

    // Helpers
    private static function generateRefreshToken() {
        return bin2hex(random_bytes(32)); // 64 hex chars
    }

    // login: devuelve access + refresh
    public static function login($config) {
        header('Content-Type: application/json');
        $pdo = getPDO($config);
        $data = json_decode(file_get_contents('php://input'), true);
        $email = $data['email'] ?? '';
        $password = $data['password'] ?? '';

        // Buscar usuario por mail (o email/mail según tu tabla)
        $stmt = $pdo->prepare("SELECT * FROM usuarios WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user || !hash_equals($user['password'], hash('sha256', $password))) {
            http_response_code(401);
            echo json_encode(['error' => 'Credenciales inválidas']);
            return;
        }

        // permisos
        $permStmt = $pdo->prepare("SELECT permiso_id FROM permisosxusuario WHERE usuario_id = ?");
        $permStmt->execute([$user['id']]);
        $permissions = $permStmt->fetchAll(PDO::FETCH_COLUMN);

        // payload JWT (access token)
        $now = time();
        $payload = [
            'sub' => (string)$user['id'],
            'email' => $user['email'],
            'name' => $user['name'],
            'permissions' => $permissions,
            'iat' => $now,
            'exp' => $now + $config['access_ttl']
        ];

        $accessToken = JWT::encode($payload, $config['jwt_secret'], 'HS256');

        // generar refresh token y guardarlo hasheado
        $refreshToken = self::generateRefreshToken();
        $refreshHash = hash('sha256', $refreshToken);
        $expiresAt = date('Y-m-d H:i:s', time() + $config['refresh_ttl']);

        $insert = $pdo->prepare("INSERT INTO refresh_tokens (usuario_id, token_hash, expires_at, created_at, ip, user_agent) VALUES (?, ?, ?, NOW(), ?, ?)");
        $ip = $_SERVER['REMOTE_ADDR'] ?? null;
        $ua = $_SERVER['HTTP_USER_AGENT'] ?? null;
        $insert->execute([$user['id'], $refreshHash, $expiresAt, $ip, $ua]);

        echo json_encode([
            'access_token' => $accessToken,
            'expires_in' => $config['access_ttl'],
            'refresh_token' => $refreshToken,
            'refresh_expires_at' => $expiresAt,
            'user' => [
                'id' => $user['id'],
                'name' => $user['name'],
                'email' => $user['email'],
                'permissions' => $permissions
            ]
        ]);
    }

    // refresh: recibe refresh_token (en body), valida, rota y devuelve tokens nuevos
    public static function refresh($config) {
        header('Content-Type: application/json');
        $pdo = getPDO($config);
        $data = json_decode(file_get_contents('php://input'), true);
        $refreshToken = $data['refresh_token'] ?? '';

        if (!$refreshToken) {
            http_response_code(400);
            echo json_encode(['error' => 'refresh_token requerido']);
            return;
        }

        $hash = hash('sha256', $refreshToken);

        // buscar token activo
        $stmt = $pdo->prepare("SELECT * FROM refresh_tokens WHERE token_hash = ? AND expires_at > NOW()");
        $stmt->execute([$hash]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$row) {
            http_response_code(401);
            echo json_encode(['error' => 'Refresh token inválido o expirado']);
            return;
        }

        $userId = $row['usuario_id'];

        // Obtener usuario y permisos
        $userStmt = $pdo->prepare("SELECT id, name, email FROM usuarios WHERE id = ?");
        $userStmt->execute([$userId]);
        $user = $userStmt->fetch(PDO::FETCH_ASSOC);
        if (!$user) {
            http_response_code(404);
            echo json_encode(['error' => 'Usuario no encontrado']);
            return;
        }
        $permStmt = $pdo->prepare("SELECT permiso_id FROM permisosxusuario WHERE usuario_id = ?");
        $permStmt->execute([$userId]);
        $permissions = $permStmt->fetchAll(PDO::FETCH_COLUMN);

        // crear nuevo access token
        $now = time();
        $payload = [
            'sub' => (string)$user['id'],
            'email' => $user['email'],
            'name' => $user['name'],
            'permissions' => $permissions,
            'iat' => $now,
            'exp' => $now + $config['access_ttl']
        ];
        $accessToken = JWT::encode($payload, $config['jwt_secret'], 'HS256');

        // rotar refresh token: borrar el anterior y crear uno nuevo
        $pdo->beginTransaction();
        try {
            // eliminar token usado
            $del = $pdo->prepare("DELETE FROM refresh_tokens WHERE id = ?");
            $del->execute([$row['id']]);

            // insertar nuevo refresh token
            $newRefresh = self::generateRefreshToken();
            $newHash = hash('sha256', $newRefresh);
            $expiresAt = date('Y-m-d H:i:s', time() + $config['refresh_ttl']);
            $insert = $pdo->prepare("INSERT INTO refresh_tokens (usuario_id, token_hash, expires_at, created_at, ip, user_agent) VALUES (?, ?, ?, NOW(), ?, ?)");
            $ip = $_SERVER['REMOTE_ADDR'] ?? null;
            $ua = $_SERVER['HTTP_USER_AGENT'] ?? null;
            $insert->execute([$userId, $newHash, $expiresAt, $ip, $ua]);

            $pdo->commit();
        } catch (Exception $e) {
            $pdo->rollBack();
            http_response_code(500);
            echo json_encode(['error' => 'Error al rotar refresh token']);
            return;
        }

        echo json_encode([
            'access_token' => $accessToken,
            'expires_in' => $config['access_ttl'],
            'refresh_token' => $newRefresh,
            'refresh_expires_at' => $expiresAt
        ]);
    }

    // logout: revoca refresh token (y opcionalmente pone access token en blacklist)
    public static function logout($config) {
        header('Content-Type: application/json');
        $pdo = getPDO($config);
        $headers = getallheaders();

        // extraer access token si vino (opcional)
        $authHeader = $headers['Authorization'] ?? '';
        $token = '';
        if ($authHeader && strpos($authHeader, 'Bearer ') === 0) {
            $token = substr($authHeader, 7);
            // opcional: insertar en blacklist
            $stmt = $pdo->prepare("INSERT INTO jwt_blacklist (token, revoked_at) VALUES (?, NOW())");
            $stmt->execute([$token]);
        }

        // revocar refresh token enviado en body (recomendado)
        $data = json_decode(file_get_contents('php://input'), true);
        $refreshToken = $data['refresh_token'] ?? '';

        if ($refreshToken) {
            $hash = hash('sha256', $refreshToken);
            $del = $pdo->prepare("DELETE FROM refresh_tokens WHERE token_hash = ?");
            $del->execute([$hash]);
        }

        echo json_encode(['ok' => true, 'message' => 'Sesión cerrada']);
    }
}
