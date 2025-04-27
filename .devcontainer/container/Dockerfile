FROM ubuntu:latest

ARG USER_UID
ARG USER_GID
ARG DOCKER_GID
ENV USERNAME=kood

# Replace default shell with bash so we can source files in the build process.
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set root password to root.
RUN echo "root:root" | chpasswd

# Update and install some basic tools.
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential \
    curl \
    unzip \
    bash \
    python3 \
    python3-pip \
    software-properties-common \
    iputils-ping \
    dnsutils \
    sudo \
    vim \
    tmux \
    net-tools \
    neofetch

# Install Java 21 and Maven.
RUN apt-get install -y \
    openjdk-21-jdk \
    maven 

# Install ngrok.
RUN curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
  | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
  | tee /etc/apt/sources.list.d/ngrok.list \
  && apt update \
  && apt install ngrok

# Add Docker's official GPG key.
RUN apt-get update && \
apt-get install -y ca-certificates curl && \
install -m 0755 -d /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's repository to Apt sources.
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo ${UBUNTU_CODENAME:-$VERSION_CODENAME}) stable" > /etc/apt/sources.list.d/docker.list && \
apt-get update

# Install CLI, Compose and Buildx, Engine is already exposed from the host by using a volume mount in compose.
RUN apt-get install -y docker-ce-cli docker-compose-plugin docker-buildx-plugin containerd.io

# Set NVM install Directory.
RUN mkdir -p /usr/local/nvm
ENV NVM_DIR=/usr/local/nvm

# Set exact Node.js version.
ENV NODE_VERSION=22.13.1

# Install nvm with node and npm.
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.40.3/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Add Node to PATH.
ENV NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Add NVM to global bashrc.
RUN echo 'export NVM_DIR=/usr/local/nvm' >> /etc/bash.bashrc && \
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/bash.bashrc

# Rice the terminal with neofetch.
RUN echo 'neofetch --jp2a /workspace/.devcontainer/assets/logo-square.png --colors 3 3 3 7 7' >> /etc/bash.bashrc

# Create a user matching host system.
RUN set -e && \
    if [[ -z "$USER_UID" || -z "$USER_GID" || -z "$USERNAME" ]]; then \
        echo "Error: USER_UID, USER_GID, and USERNAME must be provided."; \
        exit 1; \
    fi && \
    if getent passwd "$USER_UID" >/dev/null 2>&1; then \
        echo "User with UID $USER_UID exists, deleting..."; \
        userdel -r "$(getent passwd "$USER_UID" | cut -d: -f1)"; \
    fi && \
    if getent group "$USER_GID" >/dev/null 2>&1; then \
        echo "Group with GID $USER_GID exists, deleting..."; \
        groupdel "$(getent group "$USER_GID" | cut -d: -f1)"; \
    fi && \
    groupadd --gid "$USER_GID" "$USERNAME" && \
    useradd --uid "$USER_UID" --gid "$USER_GID" -m "$USERNAME" && \
    mkdir -p /etc/sudoers.d && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USERNAME" && \
    chmod 0440 "/etc/sudoers.d/$USERNAME"

# Add user to docker group.
RUN groupadd -g ${DOCKER_GID} docker && \
usermod -aG docker "${USERNAME}"

# Create symlink to workspace in users home directory.
RUN ln -s /workspace "/home/${USERNAME}/workspace" 