# USER_DOC.md — User Documentation

## 1. Services Provided
This project provides a secure, containerized web infrastructure. Each service runs in its own isolated environment:

- **NGINX**: The entry point. It serves as a secure web server using TLS (v1.2 or v1.3).
- **WordPress**: The CMS application used to manage and display website content.
- **PHP-FPM**: The FastCGI process manager that processes dynamic PHP content for WordPress.
- **MariaDB**: The relational database used to store all persistent website data and user information.



---

## 2. Managing the Project (Start/Stop)
Management of the services is handled through a **Makefile** located at the root of the project.

* **Start the infrastructure**: 
    ```bash
    make
    ```
    *This command builds the images, creates the networks/volumes, and starts the containers.*
* **Stop the infrastructure**: 
    ```bash
    make stop
    ```
    *This pauses all running services without deleting data.*
* **Full Reset**: 
    ```bash
    make fclean
    ```
    *Use this to completely remove containers, images, and all persistent data.*

---

## 3. Accessing the Website
Once the stack is running, you can access the following interfaces:

> **Important**: You must have `127.0.0.1 arcanava.42.fr` configured in your `/etc/hosts` file.

* **User Website**: [https://arcanava.42.fr](https://arcanava.42.fr)
* **WordPress Admin Dashboard**: [https://arcanava.42.fr/wp-admin](https://arcanava.42.fr/wp-admin)

---

## 4. Credentials and Security
Sensitive information is managed using environment variables to prevent accidental leaks.

* **Credential Location**: All passwords and usernames (Database, WordPress Admin, and WordPress User) are stored in secrets, declared in a file for each in **`secrets.template/`**. Those are imported via **`.env`** located in the **`srcs/`** directory where you can find the template **`.env.template`**.
* **Updates**: If you modify any credential, you must restart the system with `make re` to apply changes.

---

## 5. Service Health Checks
To verify the system is running correctly as an administrator, use these commands:

1.  **Check Container Status**:
    ```bash
    docker ps
    ```
    *Ensure all three services (nginx, wordpress, mariadb) have a status of "Up".*
2.  **Monitor Activity (Logs)**:
    ```bash
    docker-compose -f srcs/docker-compose.yml logs -f
    ```
    *This provides a real-time feed of service activity and helps diagnose connection errors.*
3.  **Network Verification**:
    ```bash
    docker network ls
    ```
    *Verify that the private network (e.g., `inception_network`) is active and connecting the containers.*