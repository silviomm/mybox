#!/bin/bash

# Add same usr
USER_ID=$(stat -c '%u' /app)
if [[ $((${USER_ID})) -eq 0 ]]; then
    /bin/docker-entrypoint.sh
else
    # Create user with default group
    GROUP_ID=$(stat -c '%g' /app)
    USERNAME=box
    addgroup --gid $GROUP_ID $USERNAME
    adduser --uid $USER_ID --gid $GROUP_ID --disabled-password --gecos "" $USERNAME

    # Add user to sudoers group
    usermod -aG sudo $USERNAME
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

    # Ensure whole folder is accessible to user box
    chown $USERNAME:$USERNAME -R /app
    # chown $USERNAME:$USERNAME -R /host-kube
    # chown $USERNAME:$USERNAME -R /host-aws

    # Allow new user to use docker
    DOCKER_GROUP_ID=$(stat -c '%g' /var/run/docker.sock)
    addgroup --gid $DOCKER_GROUP_ID docker
    usermod -aG docker $USERNAME

    # Get root environment variables to ensure new user gets the variables defined in docker-compose.yml
    printenv > /tmp/rootenv
    chmod 644 /tmp/rootenv

    su - $USERNAME -P -c "printenv > /tmp/boxenv && set -a && . /tmp/rootenv && . /tmp/boxenv && cd $(pwd) && /bin/docker-entrypoint.sh" && exit
fi;