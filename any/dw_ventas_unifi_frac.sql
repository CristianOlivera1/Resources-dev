
-- CREAR VISTA GLOBAL DEL CUBO OLAP
CREATE VIEW cubo_ventas_global AS
SELECT 
    id_hecho,
    id_tiempo,
    id_producto,
    id_cliente,
    id_region,
    id_venta,
    cantidad,
    monto_venta,
    costo_total,
    ganancia,
    margen_porcentaje,
    'América' AS origen_fragmento
FROM fact_ventas_america

UNION ALL

SELECT 
    id_hecho,
    id_tiempo,
    id_producto,
    id_cliente,
    id_region,
    id_venta,
    cantidad,
    monto_venta,
    costo_total,
    ganancia,
    margen_porcentaje,
    'Europa' AS origen_fragmento
FROM fact_ventas_europa

UNION ALL

SELECT 
    id_hecho,
    id_tiempo,
    id_producto,
    id_cliente,
    id_region,
    id_venta,
    cantidad,
    monto_venta,
    costo_total,
    ganancia,
    margen_porcentaje,
    'Asia' AS origen_fragmento
FROM fact_ventas_asia;


-- VERIFICACIÓN DE LA VISTA GLOBAL
DESCRIBE cubo_ventas_global;

SELECT COUNT(*) AS total_registros 
FROM cubo_ventas_global;

SELECT 
    origen_fragmento,
    COUNT(*) AS num_registros,
    ROUND(SUM(monto_venta), 2) AS total_ventas,
    ROUND(SUM(ganancia), 2) AS total_ganancia,
    ROUND(AVG(margen_porcentaje), 2) AS margen_promedio
FROM cubo_ventas_global
GROUP BY origen_fragmento
ORDER BY origen_fragmento;


-- CONSULTAS OLAP SOBRE LA VISTA GLOBAL
-- CONSULTA 1: Análisis Global por Continente
SELECT 
    dr.continente,
    COUNT(DISTINCT cv.id_venta) AS num_ventas,
    SUM(cv.cantidad) AS unidades_vendidas,
    ROUND(SUM(cv.monto_venta), 2) AS ventas_totales,
    ROUND(SUM(cv.ganancia), 2) AS ganancia_total,
    ROUND(AVG(cv.margen_porcentaje), 2) AS margen_promedio,
    ROUND(SUM(cv.monto_venta) * 100.0 / (SELECT SUM(monto_venta) FROM cubo_ventas_global), 2) AS porcentaje_ventas
FROM cubo_ventas_global cv
INNER JOIN dim_region dr ON cv.id_region = dr.id_region
GROUP BY dr.continente
ORDER BY ventas_totales DESC;

-- CONSULTA 2: Análisis Temporal Global
SELECT 
    dt.anio,
    dt.trimestre,
    dt.nombre_mes,
    COUNT(DISTINCT cv.id_venta) AS num_ventas,
    SUM(cv.cantidad) AS unidades_vendidas,
    ROUND(SUM(cv.monto_venta), 2) AS ventas_totales,
    ROUND(SUM(cv.ganancia), 2) AS ganancia_total
FROM cubo_ventas_global cv
INNER JOIN dim_tiempo dt ON cv.id_tiempo = dt.id_tiempo
GROUP BY dt.anio, dt.trimestre, dt.mes, dt.nombre_mes
ORDER BY dt.anio, dt.mes;

-- CONSULTA 3: Top Productos Globalmente
SELECT 
    dp.categoria,
    dp.nombre_producto,
    SUM(cv.cantidad) AS unidades_vendidas,
    COUNT(DISTINCT cv.id_region) AS regiones_vendidas,
    ROUND(SUM(cv.monto_venta), 2) AS ventas_totales,
    ROUND(SUM(cv.ganancia), 2) AS ganancia_total,
    ROUND(AVG(cv.margen_porcentaje), 2) AS margen_promedio
FROM cubo_ventas_global cv
INNER JOIN dim_producto dp ON cv.id_producto = dp.id_producto
GROUP BY dp.categoria, dp.nombre_producto
ORDER BY ganancia_total DESC
LIMIT 10;

-- CONSULTA 4: Análisis Multidimensional
-- Ventas por Continente, Trimestre y Categoría
SELECT 
    dr.continente,
    dt.trimestre,
    dp.categoria,
    COUNT(DISTINCT cv.id_venta) AS num_ventas,
    SUM(cv.cantidad) AS unidades_vendidas,
    ROUND(SUM(cv.monto_venta), 2) AS ventas_totales,
    ROUND(SUM(cv.ganancia), 2) AS ganancia_total
FROM cubo_ventas_global cv
INNER JOIN dim_region dr ON cv.id_region = dr.id_region
INNER JOIN dim_tiempo dt ON cv.id_tiempo = dt.id_tiempo
INNER JOIN dim_producto dp ON cv.id_producto = dp.id_producto
GROUP BY dr.continente, dt.trimestre, dp.categoria
ORDER BY dr.continente, dt.trimestre, ventas_totales DESC;

-- CONSULTA 5: Análisis de Clientes Global
SELECT 
    dc.segmento_cliente,
    dr.continente,
    COUNT(DISTINCT dc.id_cliente) AS num_clientes,
    COUNT(DISTINCT cv.id_venta) AS num_ventas,
    SUM(cv.cantidad) AS unidades_vendidas,
    ROUND(SUM(cv.monto_venta), 2) AS ventas_totales,
    ROUND(AVG(cv.monto_venta), 2) AS ticket_promedio,
    ROUND(SUM(cv.ganancia), 2) AS ganancia_total
FROM cubo_ventas_global cv
INNER JOIN dim_cliente dc ON cv.id_cliente = dc.id_cliente
INNER JOIN dim_region dr ON cv.id_region = dr.id_region
GROUP BY dc.segmento_cliente, dr.continente
ORDER BY dc.segmento_cliente, ventas_totales DESC;

-- CONSULTA 6: Comparación Mes a Mes Global
SELECT 
    dt.anio,
    dt.mes,
    dt.nombre_mes,
    ROUND(SUM(cv.monto_venta), 2) AS ventas_mes,
    ROUND(SUM(cv.ganancia), 2) AS ganancia_mes,
    ROUND(
        (SUM(cv.monto_venta) - LAG(SUM(cv.monto_venta)) OVER (ORDER BY dt.anio, dt.mes)) /
        LAG(SUM(cv.monto_venta)) OVER (ORDER BY dt.anio, dt.mes) * 100,
        2
    ) AS crecimiento_porcentual
FROM cubo_ventas_global cv
INNER JOIN dim_tiempo dt ON cv.id_tiempo = dt.id_tiempo
GROUP BY dt.anio, dt.mes, dt.nombre_mes
ORDER BY dt.anio, dt.mes;

-- CONSULTA 7: Matriz de Ventas
-- Continente vs Categoría
SELECT 
    dr.continente,
    SUM(CASE WHEN dp.categoria = 'Electrónica' THEN cv.monto_venta ELSE 0 END) AS Electronica,
    SUM(CASE WHEN dp.categoria = 'Ropa' THEN cv.monto_venta ELSE 0 END) AS Ropa,
    SUM(CASE WHEN dp.categoria = 'Hogar' THEN cv.monto_venta ELSE 0 END) AS Hogar,
    SUM(CASE WHEN dp.categoria = 'Deportes' THEN cv.monto_venta ELSE 0 END) AS Deportes,
    SUM(CASE WHEN dp.categoria = 'Libros' THEN cv.monto_venta ELSE 0 END) AS Libros,
    ROUND(SUM(cv.monto_venta), 2) AS Total
FROM cubo_ventas_global cv
INNER JOIN dim_region dr ON cv.id_region = dr.id_region
INNER JOIN dim_producto dp ON cv.id_producto = dp.id_producto
GROUP BY dr.continente
ORDER BY Total DESC;
