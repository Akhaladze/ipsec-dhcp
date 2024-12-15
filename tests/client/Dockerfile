FROM debian:12

# Install packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    python3-apt \
    mc \
    curl \
    nmap \
    git \
    wget \
    sudo \
    && apt-get clean

# Setup SSH
RUN mkdir /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
# Change sudo passless
RUN echo "gnet ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create user gnet
RUN useradd -m -s /bin/bash gnet && \
    echo "gnet:Frdfkfyu2023!" | chpasswd && \
    mkdir -p /home/gnet/.ssh && \
    chmod 701 /home/gnet/.ssh && \
    usermod -aG sudo gnet
# Copy SSH keys
COPY id_rsa.pub /home/gnet/.ssh/authorized_keys
RUN chmod 600 /home/gnet/.ssh/authorized_keys && \
    chown -R gnet:gnet /home/gnet/.ssh

#  Expose SSH port
EXPOSE 22

# Remove firewall
RUN apt-get remove -y ufw

CMD ["/usr/sbin/sshd", "-D"]
