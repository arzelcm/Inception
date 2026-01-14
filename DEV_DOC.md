# DEV_DOC.md — Developer Documentation

## Environment Setup
1. **Prerequisites**: Docker, Docker Compose, and Make must be installed on a Debian-based system.
2. **Secrets**: Create a `.env` file in `srcs/` using the `.env.template` template. Then create a file for each secret using the `secrets.template/` directory.

## Development Workflow
- **Build/Launch**: `make` runs `docker-compose -f srcs/docker-compose.yml up --build`.
- **Debugging**: Use `docker logs -f <container_name>` to view real-time error logs.
- **Shell Access**: Access any container with `docker exec -it <container_name> sh`.

## Data Persistence
Project data is persistent and stored on the host machine in:
- **DB Data**: `/home/arcanava/data/mariadb`
- **Site Files**: `/home/arcanava/data/wordpress`

The persistence is achieved via **Bind Mounts** defined in the `docker-compose.yml`, mapping these host paths to the container's `/var/lib/mysql` and `/var/www/html` directories respectively.