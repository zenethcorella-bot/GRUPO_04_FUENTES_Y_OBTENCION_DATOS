USE opt_portafolios;

-- ---------- Consultas ---------- --  

-- ----------- Consulta 1: Análisis de Diversificación Sectorial ----------- --
SELECT s.Sector, COUNT(a.symbol) AS numero_activos
FROM Activos a
JOIN Sectores s ON a.sector_id = s.sector_id
GROUP BY s.Sector
ORDER BY numero_activos DESC;

-- ----------- Consulta 2: Identificación de Activos de Alto Riesgo (Beta > 1.2) ----------- --
SELECT a.longName, d.beta, d.currentPrice
FROM Activos a
JOIN desempeño d ON a.symbol = d.symbol
WHERE d.beta > 1.2
ORDER BY d.beta DESC;

-- ----------- Consulta 3: Exposición Real de la Estrategia (Portafolio vs. Sector) ----------- --
SELECT p.portafolio_id, s.Sector, SUM(p.peso * 100) as porcentaje_exposicion
FROM Portafolios p
JOIN Activos a ON p.symbol = a.symbol
JOIN Sectores s ON a.sector_id = s.sector_id
GROUP BY p.portafolio_id, s.Sector;

-- ----------- Consulta 4: Ranking de Rentabilidad Intradiaria ----------- --
SELECT Simbolo, Fecha, Apertura, Cierre, ((Apertura - Cierre) / Apertura) * 100 AS variacion_porcentual
FROM Precios
ORDER BY variacion_porcentual desc
LIMIT 10;

-- ----------- Consulta 5: Concentración de Capital por Divisa ----------- --
SELECT a.financialCurrency, SUM(t.monto) AS capital_total_invertido
FROM Transaccional t
JOIN Activos a ON t.portafolio_id = (SELECT portafolio_id FROM Portafolios WHERE symbol = a.symbol LIMIT 1)
GROUP BY a.financialCurrency;

-- ----------- Consulta 6: Análisis de Volatilidad Histórica (Amplitud) ----------- --
SELECT Simbolo, MAX(Maximo) AS max_historico, MIN(Minimo) AS min_historico,
       (MAX(Maximo) - MIN(Minimo)) AS amplitud_precio
FROM Precios
GROUP BY Simbolo;

-- ----------- Consulta 7: Balance Consolidado por Inversionista (Saldo Neto) ----------- --
SELECT i.nombre, 
       SUM(CASE WHEN t.tipo_operacion = 'COMPRA' THEN t.monto ELSE -t.monto END) AS balance_neto
FROM Inversionistas i
JOIN Transaccional t ON i.inversionista_id = t.inversionista_id
GROUP BY i.nombre;

-- ----------- Consulta 8: Auditoría de Pesos de Cartera Específica ----------- --
SELECT symbol, peso
FROM Portafolios
WHERE portafolio_id = 'PORT_AGRESIVO'
ORDER BY peso DESC;