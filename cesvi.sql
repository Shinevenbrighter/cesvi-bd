SELECT user, host FROM mysql.user;

CREATE DATABASE cesvi;
USE cesvi;

-- Crear primero las tablas sin dependencias
CREATE TABLE ubicacion(	
    id_ubicacion INT AUTO_INCREMENT,
    estado VARCHAR(100),
    municipio VARCHAR(100),
    zona VARCHAR(100),
    PRIMARY KEY(id_ubicacion)
);

-- Agregué codigo postal como tabla 
CREATE TABLE codigo_postal(
	id_cp VARCHAR(5) NOT NULL,
	id_ubicacion INT,
    FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion),
    PRIMARY KEY (id_cp)


);

-- Correccion a tipo usuario
CREATE TABLE tipo_usuario(
    id_tipo_usuario INT AUTO_INCREMENT,
    tipo_usuario VARCHAR(20),
    PRIMARY KEY(id_tipo_usuario)
);


CREATE TABLE organizacion(
    id_organizacion INT AUTO_INCREMENT,
    nombre_organizacion VARCHAR(200),
    nombre_asesor VARCHAR(100),
    rfc VARCHAR(100),
    numero_fiscal VARCHAR(100),
    correo VARCHAR(100),
    telefono VARCHAR(20),
    id_ubicacion INT,
    id_cp VARCHAR(5),
    FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion),
    FOREIGN KEY (id_cp) REFERENCES codigo_postal(id_cp),

    PRIMARY KEY(id_organizacion)
);


CREATE TABLE usuario(
    id_usuario INT AUTO_INCREMENT,
    id_organizacion INT,
    id_tipo_usuario INT,
    nombre VARCHAR(30),
    apellido_paterno VARCHAR(30),
    apellido_materno VARCHAR(30),
    correo VARCHAR(100),
    PRIMARY KEY(id_usuario),
    FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario),
    FOREIGN KEY (id_organizacion) REFERENCES organizacion(id_organizacion)
);

-- Registro de las cambio dentro de la página
CREATE TABLE log_operaciones(
    id_log INT AUTO_INCREMENT,
    fecha_hora DATETIME,
    IP VARCHAR(45),
    id_usuario INT,
    accion VARCHAR(50),
    modulo VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    PRIMARY KEY(id_log)
);

-- Tipo de Unidad, Auto, Motos, equipo pesado, Multimarca, Taller
CREATE TABLE tipo_unidad( 
    id_unidad INT AUTO_INCREMENT,
    tipo_unidad VARCHAR(16),
    PRIMARY KEY(id_unidad)
);

-- Tipo de taller Agencia o Multimarca
CREATE TABLE tipo_taller(
    id_tipo_taller INT AUTO_INCREMENT,
    tipo_taller VARCHAR(50),
    PRIMARY KEY(id_tipo_taller)
);

-- Información del taller 
CREATE TABLE taller(
    id_taller INT AUTO_INCREMENT,
    id_tipo_taller INT,
    id_ubicacion INT,
    id_unidad INT,
    id_cp VARCHAR(5), 
    nombre_comercial VARCHAR(100),
    taller_exclusivo BOOLEAN,
    calificacion_cesvi FLOAT,
    estatus_cesvi VARCHAR(10),
    numero_at VARCHAR(10),
    FOREIGN KEY (id_unidad) REFERENCES tipo_unidad(id_unidad),
    FOREIGN KEY (id_tipo_taller) REFERENCES tipo_taller(id_tipo_taller),
    FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion),
    FOREIGN KEY (id_cp) REFERENCES codigo_postal(id_cp),

    PRIMARY KEY(id_taller)
);

-- Informacion llenada por Cesvi sobre los siniestros
CREATE TABLE registro_siniestro(
    id_siniestro INT AUTO_INCREMENT,
    id_organizacion INT,
    id_taller INT,
    numero_siniestro INT,
    costo_total_siniestro INT,
    costo_total_refacciones INT,
    costo_total_mano_obra_reparacion INT,
    otro_costos INT,
    numero_total_refacciones INT,
    numero_complementos INT,
    dias_estadia INT,
    mes_conclusion_siniestro INT,
    anio_conclusion_siniestro INT,															
    vehiculo VARCHAR(50),
    marca VARCHAR(20),
    anio_modelo INT,
    FOREIGN KEY (id_taller) REFERENCES taller(id_taller),
    FOREIGN KEY (id_organizacion) REFERENCES organizacion(id_organizacion),
    PRIMARY KEY(id_siniestro)
);

-- Tabla INTERVALO corregida
CREATE TABLE intervalo(
    id_intervalo VARCHAR(2),      -- Identificador del intervalo (Ej.: 'A', 'B', 'C', etc.)
    id_unidad INT,                -- Tipo de unidad (1 = Auto, 2 = Moto, 3 = Camión)
    rango_min INT,                -- Límite inferior del intervalo
    rango_max INT,                -- Límite superior del intervalo
    volumen_produccion_bajo DECIMAL(10,2), -- Volumen bajo de producción
    volumen_produccion_alto DECIMAL(10,2), -- Volumen alto de producción
    PRIMARY KEY (id_intervalo, id_unidad), -- Llave primaria compuesta
    FOREIGN KEY (id_unidad) REFERENCES tipo_unidad(id_unidad) 
);

CREATE TABLE criterio(
    id_criterio INT AUTO_INCREMENT,
    nombre_criterio VARCHAR(100),
    peso DECIMAL(5,2),						
    PRIMARY KEY(id_criterio)
);

CREATE TABLE puntaje(
    id_puntaje INT AUTO_INCREMENT,
    PRIMARY KEY(id_puntaje) 
);

-- Correcciones a esta tabla
CREATE TABLE intervalo_unidad_criterio_puntaje(
    id_organizacion INT,
    id_intervalo VARCHAR(2),
    id_unidad INT,
    id_criterio INT,
    id_puntaje INT,
    valor VARCHAR(8),
    PRIMARY KEY (id_organizacion, id_intervalo, id_unidad, id_criterio, id_puntaje),
    FOREIGN KEY (id_organizacion) REFERENCES organizacion(id_organizacion),
    FOREIGN KEY (id_intervalo, id_unidad) REFERENCES intervalo(id_intervalo, id_unidad),-- ya que "intervalo" tiene una clave primaria compuesta
    FOREIGN KEY (id_criterio) REFERENCES criterio(id_criterio),
    FOREIGN KEY (id_puntaje) REFERENCES puntaje(id_puntaje)
);
