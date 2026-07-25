-- =========================================================================
-- EVIDENCIA 3.b: INDEXACIÓN Y OPTIMIZACIÓN DE CONSULTAS
-- =========================================================================

-- 1. CREACIÓN DE DATOS MASIVOS SIMULADOS
-- Para que EXPLAIN ANALYZE muestre una diferencia real de tiempo, 
-- generamos 100,000 registros de estadísticas de bateo.
INSERT INTO estadistica_bateo (id_partido, id_jugador, turnos_al_bate, carreras, hits, jonrones)
SELECT 
    (random() * 10 + 1)::INT,       -- IDs de partidos del 1 al 10
    (random() * 50 + 1)::INT,       -- IDs de jugadores del 1 al 50
    (random() * 5)::INT,            -- Turnos al bate (0 a 5)
    (random() * 2)::INT,            -- Carreras
    (random() * 3)::INT,            -- Hits
    (random() * 1)::INT             -- Jonrones
FROM generate_series(1, 100000);


-- 2. CONSULTA ANTES DEL ÍNDICE (Captura la pantalla del resultado)
-- Buscamos el rendimiento acumulado de un jugador específico en una base de datos pesada.
EXPLAIN ANALYZE
SELECT id_jugador, SUM(hits) as total_hits, SUM(jonrones) as total_jonrones
FROM estadistica_bateo
WHERE id_jugador = 25
GROUP BY id_jugador;

-- Nota para el reporte PDF: Aquí verás un "Seq Scan" (Escaneo secuencial completo).


-- -------------------------------------------------------------------------


-- 3. CREACIÓN DEL ÍNDICE B-TREE
-- Optimizamos las búsquedas por jugador en la tabla de estadísticas masivas.
CREATE INDEX idx_estadistica_jugador ON estadistica_bateo(id_jugador);


-- 4. CONSULTA DESPUÉS DEL ÍNDICE (Captura la pantalla del resultado)
-- Ejecutamos exactamente la misma consulta para comparar el tiempo de ejecución.
EXPLAIN ANALYZE
SELECT id_jugador, SUM(hits) as total_hits, SUM(jonrones) as total_jonrones
FROM estadistica_bateo
WHERE id_jugador = 25
GROUP BY id_jugador;

-- Nota para el reporte PDF: Ahora verás un "Index Scan" o "Bitmap Index Scan".
-- El tiempo de ejecución (Execution Time) habrá bajado drásticamente.