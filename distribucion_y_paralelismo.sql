HEAD
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
=======
-- =========================================================================
-- EVIDENCIA 3.c: BASE DE DATOS DISTRIBUIDA (postgres_fdw)
-- =========================================================================

-- 1. Instalar la extensión para enlazar servidores externos
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- 2. Configurar el servidor remoto simulado (Representa la Liga de la Zona Norte)
CREATE SERVER servidor_liga_norte 
FOREIGN DATA WRAPPER postgres_fdw 
OPTIONS (host '192.168.1.100', dbname 'liga_norte_db', port '5432');

-- 3. Mapear el usuario local con las credenciales del servidor remoto
CREATE USER MAPPING FOR current_user 
SERVER servidor_liga_norte 
OPTIONS (user 'usuario_remoto', password 'clave_segura123');

-- 4. Importar la tabla externa para consultar datos históricos de otras ligas
CREATE FOREIGN TABLE jugador_historico_remoto (
    id_jugador INT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    jonrones_totales INT
) 
SERVER servidor_liga_norte 
OPTIONS (table_name 'jugadores_historicos');


SELECT * FROM jugador_historico_remoto LIMIT 5;


-- =========================================================================
-- EVIDENCIA 3.d: BASE DE DATOS PARALELA (Workers Paralelos)
-- =========================================================================

-- 1. Ajustar parámetros del planificador para forzar el uso de múltiples núcleos
SET max_parallel_workers_per_gather = 2;
SET parallel_tuple_cost = 0;
SET parallel_setup_cost = 0;

-- 2. Consulta masiva de agregación para activar los Workers Paralelos
-- Calculamos el promedio global de jonrones en toda la historia de la tabla masiva
EXPLAIN ANALYZE
SELECT id_jugador, AVG(jonrones) as promedio_jonrones
FROM estadistica_bateo
GROUP BY id_jugador;
>>>>>>> 0eb3e81775f79eabb83fe7cae3880c3f4c37ba5a
