# Use a robust base image (avoid Alpine for Agent compatibility)
# Container Name: stlab-linbox-antigravity
FROM ubuntu:22.04

# 1. Install dependencies required for the Antigravity Server installer
# The agent needs 'wget', 'tar', and 'git' to unpack itself and run.
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    tar \
    coreutils \
    build-essential \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 2. (Optional) Install Chrome for the "Browser Agent"
# The Agent needs a browser to test web apps. We must install it and patch it to run in Docker.
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable

# 3. CRITICAL BUG FIX: Set the HOME directory explicitly
# Antigravity's installer sometimes crashes silently if HOME isn't set or writable.
ENV HOME=/root
WORKDIR /workspace

# 4. Ensure the workspace directory has the correct permissions
RUN chmod -R 777 /workspace

# 5. Expose non-standard ports for external-facing connections
EXPOSE 3501

# 6. Keep the container running indefinitely so we can attach to it
# 6. Copy the server script and start it
COPY server.py /workspace/server.py
CMD ["python3", "/workspace/server.py"]