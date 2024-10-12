# Create a network
docker network create tour-of-heroes-vnet

# Create a volume for the SQL Server data
docker volume create db-data

# Run the SQL Server container
docker run -d \
--name db \
--network tour-of-heroes-vnet \
-e ACCEPT_EULA=Y \
-e SA_PASSWORD=Password123 \
--mount type=volume,source=db-data,target=/var/opt/mssql \
mcr.microsoft.com/azure-sql-edge:latest

# Build the API image
docker build -t tour-of-heroes-api:v1 tour-of-heroes-api

# Run the API container
docker run -d \
--name api \
--network tour-of-heroes-vnet \
-p 5051:5000 \
tour-of-heroes-api:v1

# Build the Angular image
docker build -t tour-of-heroes-angular:v1 -f tour-of-heroes-angular/Dockerfile.gh-copilot tour-of-heroes-angular

docker run -d \
--name web \
--network tour-of-heroes-vnet \
-p 8080:80 \
tour-of-heroes-angular:v1