-- DIMENSIONES

CREATE TABLE dim_tiempo (
    id_tiempo INT PRIMARY KEY,
    fecha DATE NOT NULL,
    dia INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    trimestre VARCHAR(2) NOT NULL,
    anio INT NOT NULL,
    dia_semana VARCHAR(20) NOT NULL,
    num_dia_semana INT NOT NULL,
    semana_anio INT NOT NULL
) ENGINE=InnoDB;

CREATE INDEX idx_fecha ON dim_tiempo(fecha);
CREATE INDEX idx_mes_anio ON dim_tiempo(mes, anio);
CREATE INDEX idx_trimestre ON dim_tiempo(trimestre, anio);

CREATE TABLE dim_producto (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL,
    margen_producto DECIMAL(5,2) NOT NULL
) ENGINE=InnoDB;

CREATE INDEX idx_categoria ON dim_producto(categoria);

CREATE TABLE dim_cliente (
    id_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE NOT NULL,
    segmento_cliente VARCHAR(20) NOT NULL,
    antiguedad_dias INT NOT NULL
) ENGINE=InnoDB;

CREATE INDEX idx_segmento ON dim_cliente(segmento_cliente);

CREATE TABLE dim_region (
    id_region INT PRIMARY KEY,
    nombre_region VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    continente VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE INDEX idx_continente ON dim_region(continente);
CREATE INDEX idx_pais ON dim_region(pais);

-- TABLA DE HECHOS

CREATE TABLE fact_ventas (
    id_hecho INT AUTO_INCREMENT PRIMARY KEY,
    id_tiempo INT NOT NULL,
    id_producto INT NOT NULL,
    id_cliente INT NOT NULL,
    id_region INT NOT NULL,
    id_venta INT NOT NULL,
    cantidad INT NOT NULL,
    monto_venta DECIMAL(12,2) NOT NULL,
    costo_total DECIMAL(12,2) NOT NULL,
    ganancia DECIMAL(12,2) NOT NULL,
    margen_porcentaje DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo),
    FOREIGN KEY (id_producto) REFERENCES dim_producto(id_producto),
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    FOREIGN KEY (id_region) REFERENCES dim_region(id_region)
) ENGINE=InnoDB;

CREATE INDEX idx_tiempo_region ON fact_ventas(id_tiempo, id_region);
CREATE INDEX idx_producto_tiempo ON fact_ventas(id_producto, id_tiempo);
CREATE INDEX idx_cliente_tiempo ON fact_ventas(id_cliente, id_tiempo);
CREATE INDEX idx_region_producto ON fact_ventas(id_region, id_producto);
