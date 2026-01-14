*This project has been created as part of the 42 curriculum by arcanava.*

## Description
The **Inception** project is a fundamental exercise in System Administration and DevOps. The goal is to set up a small-scale, multi-container infrastructure using **Docker Compose**. 

### Goal and Overview
The project aims to broaden knowledge of virtualization by orchestrating three mandatory services:
1.  **NGINX**: A web server with TLS v1.2/1.3.
2.  **WordPress + PHP-FPM**: A content management system.
3.  **MariaDB**: A relational database.

### Use of Docker and Sources
In this project, Docker is used to create an isolated environment where each service runs in its own container. Unlike standard container usage, this project forbids using pre-made images from Docker Hub (except for base images like Debian or Alpine). 
**The sources included in this project are:**
* **Dockerfiles**: Custom blueprints for building each service's image from scratch.
* **Configuration Files**: Setup files for NGINX (TLS/SSL), WordPress, and MariaDB.
* **Scripts**: Shell scripts (`.sh`) used as entrypoints to initialize databases and configure WordPress users dynamically.
* **Makefile**: A tool to automate the build, launch, and cleanup process.

### Main Design Choices
* **Service Isolation**: Each service communicates through a custom private network, and only NGINX is exposed to the host.
* **Persistence**: Data is kept safe using managed volumes, ensuring that if a container is deleted, the website content and database remain intact.
* **Security**: Minimalist base images (Debian Bullseye) are used to reduce the attack surface.

---

## Technical Comparisons

### Virtual Machines vs Docker

* **Virtual Machines (VMs)**: Virtualize the hardware. Each VM includes a full Guest Operating System, its own kernel, and virtual hardware. This results in high resource consumption and slow boot times.
* **Docker**: Virtualizes the Operating System kernel. Containers share the Host OS kernel but run in isolated user spaces. They are significantly more lightweight, start in seconds, and use fewer resources than VMs.

### Secrets vs Environment Variables
* **Environment Variables**: Useful for non-sensitive configuration (like service names or ports). However, they are easily visible in container metadata (`docker inspect`), making them unsafe for passwords.
* **Secrets**: Designed for sensitive data. In advanced Docker setups (like Swarm), secrets are encrypted and provided only to the authorized container in memory. In this project, we handle sensitivity via a `.env` file that is kept out of version control to simulate this security layer.

### Docker Network vs Host Network
* **Docker Network (Bridge)**: Creates an isolated internal network. This is the **default and recommended choice**. It allows containers to talk to each other using internal DNS (container names) while remaining hidden from the host's physical network.
* **Host Network**: The container shares the host's IP and port range directly. There is no isolation, which is slightly faster but significantly less secure and prone to port conflicts.

### Docker Volumes vs Bind Mounts

* **Docker Volumes**: Managed entirely by Docker within a specific area of the host filesystem (`/var/lib/docker/volumes`). They are easier to back up, migrate, and are preferred for production.
* **Bind Mounts**: Link a specific, user-defined path on the host directly to the container (e.g., `/home/arcanava/data`). They depend on the host's directory structure but are excellent for manually inspecting data.

---

## Instructions

### Compilation & Installation
1.  **Configure local DNS**:
    Add the following line to your `/etc/hosts` file:
    `127.0.0.1 arcanava.42.fr`
2.  **Prepare data directories**:
    Create the folders for the volumes (usually in `/home/arcanava/data/mariadb` and `/home/arcanava/data/wordpress`).

### Execution
Use the provided **Makefile** to manage the infrastructure:
* **Build and start**: `make` (or `make all`)
* **Stop services**: `make down`
* **Remove containers/networks**: `make clean`
* **Full Reset**: `make fclean` (removes images and volumes as well)

---

## Resources
* [Official Docker Documentation](https://docs.docker.com/)
* [NGINX TLS/SSL Setup Guide](https://nginx.org/en/docs/http/configuring_https_servers.html)
* [WordPress CLI Documentation](https://make.wordpress.org/cli/handbook/guides/installing/)

### Use of AI
AI (Large Language Models) was used in this project for:
* **Debugging**: Identifying syntax errors in `docker-compose.yml` and troubleshooting the connection between PHP-FPM and NGINX.
* **Scripting**: Generating the logic for the MariaDB setup script to ensure the root password is set securely.
* **Documentation**: Assisting in the clear articulation of the technical comparisons and structuring this README file and other documentation files.