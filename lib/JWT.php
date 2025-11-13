<?php
class JWT {
    public static function encode($payload, $key, $alg = 'HS256') {
        $header = ['typ' => 'JWT', 'alg' => $alg];
        $segments = [
            self::urlsafeB64Encode(json_encode($header)),
            self::urlsafeB64Encode(json_encode($payload))
        ];
        $signing_input = implode('.', $segments);
        $signature = self::sign($signing_input, $key, $alg);
        $segments[] = self::urlsafeB64Encode($signature);
        return implode('.', $segments);
    }

    public static function decode($jwt, $key, $allowed_algs = ['HS256']) {
        $tks = explode('.', $jwt);
        if (count($tks) != 3) {
            throw new Exception('Wrong number of segments');
        }
        list($headb64, $bodyb64, $cryptob64) = $tks;
        $header = json_decode(self::urlsafeB64Decode($headb64), true);
        $payload = json_decode(self::urlsafeB64Decode($bodyb64), true);
        $sig = self::urlsafeB64Decode($cryptob64);

        if (empty($header['alg']) || !in_array($header['alg'], $allowed_algs)) {
            throw new Exception('Algorithm not allowed');
        }

        $valid_sig = self::sign("$headb64.$bodyb64", $key, $header['alg']);
        if (!hash_equals($sig, $valid_sig)) {
            throw new Exception('Signature verification failed');
        }

        return $payload;
    }

    private static function sign($msg, $key, $alg = 'HS256') {
        switch ($alg) {
            case 'HS256':
                return hash_hmac('sha256', $msg, $key, true);
            default:
                throw new Exception('Unsupported or invalid signing algorithm');
        }
    }

    private static function urlsafeB64Encode($data) {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    private static function urlsafeB64Decode($data) {
        $remainder = strlen($data) % 4;
        if ($remainder) {
            $padlen = 4 - $remainder;
            $data .= str_repeat('=', $padlen);
        }
        return base64_decode(strtr($data, '-_', '+/'));
    }
}
