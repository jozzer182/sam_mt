FROM ubuntu:22.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install curl git unzip xz-utils zip libglu1-mesa wget \
    && apt-get -y install clang cmake ninja-build pkg-config libgtk-3-dev \
    && apt-get -y install software-properties-common \
    && apt-get -y install openjdk-11-jdk \
    && apt-get -y install build-essential

# Add a non-root user for VSCode
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid 1000 -m vscode \
    && apt-get install -y sudo \
    && echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

# Setup Flutter
USER vscode
RUN mkdir -p /home/vscode/flutter
WORKDIR /home/vscode

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Set up environment variables
ENV PATH="/home/vscode/flutter/bin:${PATH}"

# Install NVM, Node.js and Firebase CLI
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install 20 \
    && npm install -g firebase-tools

# Add NVM initialization to bashrc so it's always available
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc \
    && echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

# Run flutter doctor to download Dart SDK and validate installation
RUN flutter doctor

# Install Android SDK
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT=/home/vscode/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Reset DEBIAN_FRONTEND to default
ENV DEBIAN_FRONTEND=dialog

# Set the default shell to bash instead of sh
ENV SHELL /bin/bash