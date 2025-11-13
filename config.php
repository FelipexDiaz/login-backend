<?php
return [
    'db_host' => 'localhost',
    'db_name' => 'test',
    'db_user' => 'root',
    'db_pass' => '',
    'jwt_secret' => 'TuClaveUltraSegura123', // cámbiala
    'access_ttl' => 600,    // 10 minutos
    'refresh_ttl' => 60*60*24*7 // 7 días
];
