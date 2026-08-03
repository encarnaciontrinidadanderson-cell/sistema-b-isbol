-- 1. Habilitar la extensión de base de datos distribuida
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 2. Crear el servidor remoto virtual (apuntando a tu localhost para la simulación)
CREATE SERVER servidor_remoto
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host '127.0.0.1', port '5432', dbname 'postgres'); -- O puedes usar 'ligabeisbol_remota' si la creaste

-- 3. Crear el mapeo de usuario para permitir el acceso
CREATE USER MAPPING FOR postgres
SERVER servidor_remoto
OPTIONS (user 'postgres', password 'TU_CONTRASEÑA_AQUÍ'); -- <--- Cambia esto por tu contraseña real

-- 4. Crear una tabla foránea de prueba para evidenciar el funcionamiento remoto
CREATE FOREIGN TABLE equipo_remoto (
    id INT,
    nombre VARCHAR(100),
    ciudad VARCHAR(100)
)
SERVER servidor_remoto
OPTIONS (schema_name 'public', table_name 'equipo');


SELECT * FROM equipo_remoto;