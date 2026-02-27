CREATE DATABASE IF NOT EXISTS opt_portafolios ;
USE opt_portafolios;

-- 1. Tabla Sectores
create table Sectores(
sector_id int primary key,
Sector VARCHAR(50) NOT NULL,
Descripcion VARCHAR(150) NOT NULL,
Industria VARCHAR(50) NOT NULL,
Region VARCHAR(50) NOT NULL,
benchmark_index VARCHAR(50) NOT NULL,
riesgo_relativo VARCHAR(50)
);

-- 2. Tabla Inversionistas
CREATE TABLE Inversionistas(
inversionista_id INT PRIMARY KEY,
nombre varchar(10),
capital_total DECIMAL(20,4) DEFAULT 0.00)
;

-- 3. Tabla Activos
CREATE TABLE Activos (
    symbol VARCHAR(10) PRIMARY KEY,
    longName VARCHAR(255) NOT NULL,
    typeDisp VARCHAR(50),
    sector_id INT,
    country VARCHAR(50),
    financialCurrency VARCHAR(25),
    CONSTRAINT fk_sector FOREIGN KEY (sector_id) 
        REFERENCES Sectores(sector_id) ON DELETE SET NULL
) ;

-- 4. Tabla de Precios 
CREATE TABLE Precios (
    ID VARCHAR(50) PRIMARY KEY, 
    Simbolo VARCHAR(10) NOT NULL,
    Fecha DATE NOT NULL,
    Apertura DECIMAL(20, 6),
    Cierre DECIMAL(20, 6),
    Maximo DECIMAL(20, 6),
    Minimo DECIMAL(20, 6),
    Volumen bigint,
    CONSTRAINT fk_activo_precios FOREIGN KEY (Simbolo) 
        REFERENCES Activos(symbol) ON DELETE CASCADE
) ;

-- 5. Tabla de Desempeño 
CREATE TABLE desempeño (
    symbol VARCHAR(10) PRIMARY KEY,
    currentPrice DECIMAL(20, 6),
    previousClose DECIMAL(20, 6),
    dayLow DECIMAL(20, 6),
    dayHigh DECIMAL(20, 6),
    marketCap BIGINT,
    beta DECIMAL(20, 6),
    rendimiento DECIMAL(20, 6),
    CONSTRAINT fk_activo_desempeno FOREIGN KEY (symbol) 
        REFERENCES Activos(symbol) ON DELETE CASCADE
) ;

-- 6. Tabla de Portafolios 
CREATE TABLE Portafolios (
    portafolio_id VARCHAR(50),
    symbol VARCHAR(10),
    peso DECIMAL(5, 2),
    PRIMARY KEY (portafolio_id, symbol),
    CONSTRAINT fk_activo_portafolio FOREIGN KEY (symbol) 
        REFERENCES Activos(symbol),
    CONSTRAINT chk_peso CHECK (peso >= 0 AND peso <= 1)
) ;

-- 7. Tabla Transaccional 
CREATE TABLE Transaccional (
    transaccion_id INT AUTO_INCREMENT PRIMARY KEY,
    inversionista_id INT,
    portafolio_id VARCHAR(50),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_operacion VARCHAR(10),
    monto DECIMAL(20, 4),
    CONSTRAINT fk_inversionista FOREIGN KEY (inversionista_id) 
        REFERENCES Inversionistas(inversionista_id),
    CONSTRAINT fk_portafolio_transaccional FOREIGN KEY (portafolio_id) 
        REFERENCES Portafolios(portafolio_id)
) ;

SHOW tables;

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
