<?php
// =====================================================
// 🔹 Habilitar CORS (Cross-Origin Resource Sharing)
// =====================================================
header("Access-Control-Allow-Origin: http://localhost:5173");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Credentials: true");

// 🔹 Manejo de preflight OPTIONS (importante para CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require 'lib/flight/Flight.php';
require_once __DIR__ . '/src/db.php';
require_once __DIR__ . '/src/AuthController.php';
require_once __DIR__ . '/lib/JWT.php';
require_once __DIR__ . '/lib/Key.php';

$config = require __DIR__ . '/config.php';

// helper: verifica access token (y blacklist)
function decodeAccessToken($config) {
    $headers = getallheaders();
    if (empty($headers['Authorization'])) {
        throw new Exception('Falta token');
    }
    $authHeader = $headers['Authorization'];
    if (strpos($authHeader, 'Bearer ') !== 0) {
        throw new Exception('Formato inválido');
    }
    $token = substr($authHeader, 7);

    // revisar blacklist
    $pdo = getPDO($config);
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM jwt_blacklist WHERE token = ?");
    $stmt->execute([$token]);
    if ($stmt->fetchColumn() > 0) {
        throw new Exception('Token revocado');
    }

    $decoded = JWT::decode($token, $config['jwt_secret'], ['HS256']);
    if (is_object($decoded)) $decoded = (array)$decoded;
    return [$decoded, $token];
}

// rutas
Flight::route('POST /login', function() use ($config) {
    AuthController::login($config);
});

Flight::route('POST /refresh', function() use ($config) {
    AuthController::refresh($config);
});

Flight::route('POST /logout', function() use ($config) {
    AuthController::logout($config);
});

Flight::route('GET /user', function() use ($config) {
    header('Content-Type: application/json');
    try {
        list($decoded,) = decodeAccessToken($config);
        $pdo = getPDO($config);

        $stmt = $pdo->prepare("SELECT id, name, email FROM usuarios WHERE id = ?");
        $stmt->execute([$decoded['sub']]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$user) {
            http_response_code(404);
            echo json_encode(['error' => 'Usuario no encontrado']);
            return;
        }
        $permStmt = $pdo->prepare("SELECT permiso_id FROM permisosxusuario WHERE usuario_id = ?");
        $permStmt->execute([$user['id']]);
        $permissions = $permStmt->fetchAll(PDO::FETCH_COLUMN);
        $user['permissions'] = $permissions;

        echo json_encode(['ok'=>true,'user'=>$user]);
    } catch (Exception $e) {
        http_response_code(401);
        echo json_encode(['error'=>'Token inválido','message'=>$e->getMessage()]);
    }
});

Flight::route('GET /modulos', function() use ($config) {
    header('Content-Type: application/json');
    try {
        list($decoded, ) = decodeAccessToken($config);
        $usuario_id = $decoded['sub']; // asumiendo claim 'sub' contiene el id

        $pdo = getPDO($config);

        $sql = "
            SELECT m.id, m.nombre, m.ruta, m.componente
            FROM modulosxusuario mu
            JOIN modulos m ON mu.modulo_id = m.id
            WHERE mu.usuario_id = ? AND m.activo = 1
            ORDER BY m.id
        ";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$usuario_id]);
        $modulos = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['ok' => true, 'modulos' => $modulos]);
    } catch (\Firebase\JWT\ExpiredException $e) {
        http_response_code(401);
        echo json_encode(['error' => 'Token expirado', 'message' => $e->getMessage()]);
    } catch (Exception $e) {
        http_response_code(401);
        echo json_encode(['error' => 'No autorizado', 'message' => $e->getMessage()]);
    }
});


Flight::start();
