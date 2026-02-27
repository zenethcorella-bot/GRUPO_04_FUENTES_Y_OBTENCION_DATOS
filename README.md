Sistema de Gestión de Base de Datos – Portafolio de Inversiones (MVP)

# Descripción
Este proyecto implementa un modelo relacional para la gestión de portafolios de inversión utilizando MySQL ejecutado mediante Docker.
El sistema es completamente reproducible en local sin dependencias externas.
________________________________________
# Requisitos
•	Docker
________________________________________
# Estructura del proyecto (Carpeta SQL_Portafolios)
•	docker-compose.yml
•	01_schema.sql
•	02_data_load.sql
•	03_queries.sql
•	README.md
________________________________________
# Ejecución
Desde la carpeta del proyecto ejecutar (SQL_Portafolios):

docker-compose down -v

docker-compose up -d

# El contenedor creado es:
inversiones_mysql

# La base de datos creada es:
DB_opt_portafolios

# Puerto expuesto:
3307
________________________________________
# Conexión desde terminal
docker exec -it inversiones_mysql mysql -uroot -p200199Ra.
Luego:
	USE DB_opt_portafolios;
	SHOW TABLES;
________________________________________
# Ejecución de consultas representativas
docker exec -i inversiones_mysql mysql -uroot -p200199Ra. DB_opt_portafolios < 03_queries.sql
________________________________________
# Validación
El sistema se considera reproducible si:

•	El contenedor se levanta sin errores.

•	Las tablas se crean automáticamente.

•	Los datos se cargan correctamente.

•	Las consultas devuelven resultados coherentes.

