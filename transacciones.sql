=========================================================================
-- EVIDENCIA 3.a: GESTIÓN DE TRANSACCIONES (BEGIN, COMMIT, ROLLBACK)
-- =========================================================================

-- ============================================================
-- CASO 1: TRANSACCIÓN EXITOSA (COMMIT)
-- ============================================================

BEGIN;

INSERT INTO partido (
    fecha,
    hora,
    id_estadio,
    equipo_local,
    equipo_visitante,
    estado
)
VALUES (
    '2026-11-15',
    '19:30:00',
    1,
    1,
    2,
    'Programado'
);

COMMIT;

-- Verificación
SELECT *
FROM partido
WHERE fecha = '2026-11-15';


-- ============================================================
-- CASO 2: TRANSACCIÓN REVERTIDA (ROLLBACK)
-- ============================================================

BEGIN;

INSERT INTO partido (
    fecha,
    hora,
    id_estadio,
    equipo_local,
    equipo_visitante,
    estado
)
VALUES (
    '2026-11-16',
    '16:00:00',
    1,
    1,
    1,
    'Programado'
);

ROLLBACK;

-- Verificación
SELECT *
FROM partido
WHERE fecha = '2026-11-16';