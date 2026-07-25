CREATE DATABASE liga_beisbol;

-- BASE DE DATOS LIGA DE BEISBOL
-- CREACIÓN DE TABLAS
-- =====================================

CREATE TABLE equipo (
    id_equipo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    anio_fundacion INT,
    manager VARCHAR(100)
);

CREATE TABLE estadio (
    id_estadio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    capacidad INT
);

CREATE TABLE jugador (
    id_jugador SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    posicion VARCHAR(50),
    numero INT,
    salario NUMERIC(10,2),
    id_equipo INT NOT NULL,
    CONSTRAINT fk_jugador_equipo
        FOREIGN KEY (id_equipo)
        REFERENCES equipo(id_equipo)
);

CREATE TABLE arbitro (
    id_arbitro SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50)
);

CREATE TABLE partido (
    id_partido SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    id_estadio INT NOT NULL,
    equipo_local INT NOT NULL,
    equipo_visitante INT NOT NULL,
    carreras_local INT DEFAULT 0,
    carreras_visitante INT DEFAULT 0,
    estado VARCHAR(30),

    CONSTRAINT fk_partido_estadio
        FOREIGN KEY (id_estadio)
        REFERENCES estadio(id_estadio),

    CONSTRAINT fk_equipo_local
        FOREIGN KEY (equipo_local)
        REFERENCES equipo(id_equipo),

    CONSTRAINT fk_equipo_visitante
        FOREIGN KEY (equipo_visitante)
        REFERENCES equipo(id_equipo)
);

CREATE TABLE partido_arbitro (
    id_partido INT,
    id_arbitro INT,

    PRIMARY KEY (id_partido, id_arbitro),

    CONSTRAINT fk_pa_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido(id_partido),

    CONSTRAINT fk_pa_arbitro
        FOREIGN KEY (id_arbitro)
        REFERENCES arbitro(id_arbitro)
);

CREATE TABLE estadistica_jugador (
    id_estadistica SERIAL PRIMARY KEY,
    id_partido INT NOT NULL,
    id_jugador INT NOT NULL,
    turnos INT DEFAULT 0,
    hits INT DEFAULT 0,
    jonrones INT DEFAULT 0,
    carreras INT DEFAULT 0,
    impulsadas INT DEFAULT 0,
    ponches INT DEFAULT 0,

    CONSTRAINT fk_estadistica_partido
        FOREIGN KEY (id_partido)
        REFERENCES partido(id_partido),

    CONSTRAINT fk_estadistica_jugador
        FOREIGN KEY (id_jugador)
        REFERENCES jugador(id_jugador)
);

CREATE TABLE tabla_posiciones (
    id_equipo INT PRIMARY KEY,
    juegos INT DEFAULT 0,
    ganados INT DEFAULT 0,
    perdidos INT DEFAULT 0,
    porcentaje NUMERIC(5,3),

    CONSTRAINT fk_posiciones_equipo
        FOREIGN KEY (id_equipo)
        REFERENCES equipo(id_equipo)
);

- CREACIÓN DE TABLAS ADICIONALES (CONTINUACIÓN)
-- =======================================================

CREATE TABLE partido (
    id_partido SERIAL PRIMARY KEY,
    id_equipo_local INT NOT NULL,
    id_equipo_visitante INT NOT NULL,
    id_estadio INT NOT NULL,
    fecha TIMESTAMP NOT NULL,
    carreras_local INT DEFAULT 0,
    carreras_visitante INT DEFAULT 0,
    estado VARCHAR(20) DEFAULT 'Programado', -- Programado, En Progreso, Finalizado
    CONSTRAINT fk_partido_local FOREIGN KEY (id_equipo_local) REFERENCES equipo(id_equipo),
    CONSTRAINT fk_partido_visitante FOREIGN KEY (id_equipo_visitante) REFERENCES equipo(id_equipo),
    CONSTRAINT fk_partido_estadio FOREIGN KEY (id_estadio) REFERENCES estadio(id_estadio),
    CONSTRAINT chk_equipos_distintos CHECK (id_equipo_local <> id_equipo_visitante)
);

CREATE TABLE estadistica_bateo (
    id_estadistica SERIAL PRIMARY KEY,
    id_partido INT NOT NULL,
    id_jugador INT NOT NULL,
    turnos_al_bate INT DEFAULT 0,
    carreras INT DEFAULT 0,
    hits INT DEFAULT 0,
    jonrones INT DEFAULT 0,
    CONSTRAINT fk_est_partido FOREIGN KEY (id_partido) REFERENCES partido(id_partido),
    CONSTRAINT fk_est_jugador FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador)
);