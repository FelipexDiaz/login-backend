<?php
require_once __DIR__ . '/../lib/JWT.php';
require_once __DIR__ . '/../lib/Key.php';

class AuthMiddleware
{
    /**
     * Verifica que el token JWT sea válido y lo devuelve decodificado.
     */
    public static function verify($config)
    {
        $headers = getallheaders();
        if (!isset($headers['Authorization'])) {
            http_response_code(401);
            echo json_encode(['error' => 'Token no proporcionado']);
            exit;
        }

        $token = str_replace('Bearer ', '', $headers['Authorization']);

        try {
            // Decodifica el token
            $decoded = JWT::decode($token, $config['jwt_secret'], ['HS256']);

            // Convertimos a array por seguridad
            if (is_object($decoded)) {
                $decoded = json_decode(json_encode($decoded), true);
            }

            return $decoded;

        } catch (Exception $e) {
            http_response_code(401);
            echo json_encode(['error' => 'Token inválido', 'detalle' => $e->getMessage()]);
            exit;
        }
    }

    /**
     * Requiere que el usuario tenga un permiso específico.
     */
    public static function requirePermission($config, $permissionId)
    {
        $decoded = self::verify($config);

        if (!isset($decoded['permissions']) || !in_array($permissionId, $decoded['permissions'])) {
            http_response_code(403);
            echo json_encode(['error' => 'Acceso denegado. No posee el permiso requerido.']);
            exit;
        }
    }
}
