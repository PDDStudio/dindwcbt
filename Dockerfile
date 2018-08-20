# FROM ubuntu:18.04
FROM gitlab/dind

RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# download, install & start docker
#RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
#    chmod +x get-docker.sh && \
#    sh get-docker.sh

# download and setup dumb-init
RUN curl -s -L -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
    chmod +x /usr/local/bin/dumb-init

RUN ln -s /usr/bin/docker /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker

#RUN curl -s -L -o /usr/local/bin/wrapdocker https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker && \
#    chmod +x /usr/local/bin/wrapdocker
# create new user as which we want to run further commands
RUN groupadd -r appuser && \
    useradd appuser -r -s /bin/bash -m -g appuser -G root,sudo,docker && \
    usermod -a -G docker appuser

USER appuser
WORKDIR /home/appuser

COPY --chown=appuser:appuser . .
# Install node via nvm
RUN find . -name '*.sh' -exec chmod a+x {} \;  && \
    mkdir -p $HOME/build && \
    $HOME/nvm-install.sh && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \
    \. "$NVM_DIR/nvm.sh" && \
    nvm install node --latest-npm && \
    nvm alias default node && \
    echo "Installation complete!" && \
    echo "==== BEGIN ENV SETUP ====" && \
    echo "Using Docker Version: $(docker version)" && \
    echo "Using docker-compose Version: $(docker-compose version)" && \
    echo "Node Version: $(node -v)" && \
    echo "NPM Version: $(npm -v)" && \
    echo "==== END ENV SETUP ===="

VOLUME [ "/home/appuser/build" ]
ENV BASH_ENV "/home/appuser/.bashrc"
# VOLUME /home/appuser
ENTRYPOINT [ "/usr/local/bin/dumb-init", "--" ]
CMD [ "./docker-entrypoint.sh", "/usr/local/bin/docker", "version" ]
