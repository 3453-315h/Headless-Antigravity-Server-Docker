# Headless Antigravity Server Docker Setup

This guide provides instructions for setting up the Antigravity Agent in a Docker container on a Linux terminal-only PC.

## Prerequisites
- Docker installed on the Linux PC.
- Basic familiarity with the Linux terminal.

## Setup Instructions

### 1. Prepare the Workspace
1. Create the workspace directory:
   ```bash
   mkdir -p /home/darb/workspace
   cd /home/darb/workspace
   ```

2. Copy the `Dockerfile` to `/home/darb/workspace`.

### 2. Build the Docker Image
Run the following command to build the Docker image:
```bash
docker build -t antigravity-agent-box .
```

### 3. Run the Container
Start the Docker container with the correct volume mount and expose the non-standard port:
```bash
docker run -d --name stlab-linbox-antigravity -v "/home/darb/workspace:/workspace" -p 3501:3501 antigravity-agent-box
```
- `-v "/home/darb/workspace:/workspace"`: Mounts `/home/darb/workspace` to `/workspace` in the container.
- `-p 3501:3501`: Maps port `3501` in the container to port `3501` on the host for external access.

### 4. Verify the Setup
1. Check the container status:
   ```bash
   docker ps
   ```
   - Expected output: The container `stlab-linbox-antigravity` should be running.

2. Test file sync:
   - Create a file on the host:
     ```bash
     echo "Linux test" > /home/darb/workspace/test_linux.md
     ```
   - Check if it appears in the container:
     ```bash
     docker exec stlab-linbox-antigravity ls /workspace/test_linux.md
     ```

### 5. Use the Antigravity Agent
1. Attach to the container:
   ```bash
   docker exec -it stlab-linbox-antigravity /bin/bash
   ```
   - This gives you a shell inside the container.

2. Run scripts:
   - Execute Python scripts or other commands inside the container:
     ```bash
     python3 /workspace/hello_world.py
     ```

### 6. Connect via LAN
To connect to the container from another machine on the same LAN:

1. **Find the Container's IP Address**:
   ```bash
   docker inspect stlab-linbox-antigravity | grep IPAddress
   ```
   - Expected output: The container's IP address (e.g., `172.17.0.2`).

2. **Connect via LAN**:
   - Use the container's IP address and the exposed port to connect from another machine:
     ```
     http://<container-ip>:3501
     ```
   - Replace `<container-ip>` with the container's actual IP address.

3. **Verify the Connection**:
   - From the host machine:
     ```bash
     curl http://<container-ip>:3501
     ```
   - From another machine on the LAN:
     ```bash
     curl http://<container-ip>:3501
     ```

### 7. Connect the IDE (Optional)
If you want to connect an IDE (e.g., VS Code) to the running container:

1. **Install the Remote - Containers Extension**:
   - Open VS Code.
   - Install the **Remote - Containers** extension from the Extensions Marketplace.

2. **Attach to the Running Container**:
   - Open the **Command Palette** (`Ctrl + Shift + P`).
   - Select **Dev Containers: Attach to Running Container**.
   - Choose `stlab-linbox-antigravity` from the list.

3. **Open the Workspace**:
   - In the container, open the `/workspace` directory to access your files.

4. **Use the Antigravity Agent**:
   - Use the Agent to create files or perform tasks.
   - Verify that files created by the Agent appear in the host directory.

## Workflow
- **Host (Linux PC)**: Edit files in `/home/darb/workspace`.
- **Container**: Handles runtime dependencies (Python, Chrome, etc.).
- **File Sync**: Changes on the host appear in the container, and vice versa.




### 8. if your on remote network then setup ssh to access it.

1. edit your C:\Users\YourName\.ssh\config (Windows) in any text editor. (if the file is not there create it)

2. Add the following entry:

Host my-dev-container-host
    HostName <REMOTE-IP-ADDRESS>
    User <REMOTE-USERNAME>
    IdentityFile ~/.ssh/id_rsa

3. In Antigravity, open the Command Palette (Ctrl+Shift+P or Cmd+Shift+P).

4. Type "Connect to Host" (or "Remote-SSH: Connect to Host").

5. Select my-dev-container-host.







## Key Commands
| Task                     | Command                                                                 |
|--------------------------|-------------------------------------------------------------------------|
| **Build Image**          | `docker build -t antigravity-agent-box .`                                |
| **Run Container**        | `docker run -d --name stlab-linbox-antigravity -v "/home/darb/workspace:/workspace" antigravity-agent-box` |
| **Attach to Container**  | `docker exec -it stlab-linbox-antigravity /bin/bash`                    |
| **Stop Container**       | `docker stop stlab-linbox-antigravity`                                   |
| **Remove Container**     | `docker rm stlab-linbox-antigravity`                                     |

## Troubleshooting
- **Image Not Found**: Ensure the Docker image is built with the correct name (`antigravity-agent-box`).
- **Permission Issues**: Ensure the user has permissions to access Docker and the workspace directory.
- **File Sync Issues**: Verify the volume mount is correctly configured.

## Notes
- The container does not require exposed ports unless you are running additional services.
- The Antigravity Agent uses the container for runtime dependencies while you work on the host.

## License
This project is licensed under the MIT License.
