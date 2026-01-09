-- FRAGMENTO 1: AMÉRICA
CREATE TABLE fact_ventas_america (
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

CREATE INDEX idx_tiempo_region_america ON fact_ventas_america(id_tiempo, id_region);
CREATE INDEX idx_producto_america ON fact_ventas_america(id_producto);
CREATE INDEX idx_cliente_america ON fact_ventas_america(id_cliente);

-- FRAGMENTO 2: EUROPA
CREATE TABLE fact_ventas_europa (
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

CREATE INDEX idx_tiempo_region_europa ON fact_ventas_europa(id_tiempo, id_region);
CREATE INDEX idx_producto_europa ON fact_ventas_europa(id_producto);
CREATE INDEX idx_cliente_europa ON fact_ventas_europa(id_cliente);

-- FRAGMENTO 3: ASIA
CREATE TABLE fact_ventas_asia (
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

CREATE INDEX idx_tiempo_region_asia ON fact_ventas_asia(id_tiempo, id_region);
CREATE INDEX idx_producto_asia ON fact_ventas_asia(id_producto);
CREATE INDEX idx_cliente_asia ON fact_ventas_asia(id_cliente);

-- PASO 3: CARGAR DATOS EN FRAGMENTOS

-- Cargar AMÉRICA (continente = 'América')
INSERT INTO fact_ventas_america (
    id_tiempo, id_producto, id_cliente, id_region, id_venta,
    cantidad, monto_venta, costo_total, ganancia, margen_porcentaje
)
