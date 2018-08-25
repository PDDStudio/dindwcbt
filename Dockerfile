# FROM ubuntu:18.04
FROM gitlab/dind

RUN apt-get update -qqy && \
    apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm3 \
    libgdbm-dev

COPY ./data/system/profile.d/rbenv-init.sh /etc/profile.d/rbenv-init.sh

# download and setup dumb-init
RUN curl -s -L -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
    chmod +x /usr/local/bin/dumb-init

# symlink docker binary
RUN ln -s /usr/bin/docker /usr/local/bin/docker && \
    chmod +x /usr/local/bin/docker

# create new user as which we want to run further commands
RUN groupadd -r appuser && \
    useradd appuser -r -s /bin/bash -m -g appuser -G root,sudo,docker && \
    usermod -a -G docker appuser

# set user & workdir to execute further setup without being root
USER appuser
WORKDIR /home/appuser

# copy rc, config & setup files to container
COPY --chown=appuser:appuser data/user .
COPY --chown=appuser:appuser data/temp ./temp

ENV TARGET_RUBY_VERSION=${TARGET_VERSION_RUBY:-2.5.0}
ENV TARGET_NODE_VERSION=${TARGET_VERSION_NODE:-10.9.0}

ENV PATH $HOME/.rbenv/bin:$PATH

# create required directories
RUN mkdir -p $HOME/build && \
    mkdir -p $HOME/tmp && \
    mkdir -p $HOME/local && \
    mkdir -p $HOME/.nvm

# download, setup and install rbenv & nvm
RUN bash -l -c "\
    git config --global http.sslVerify false; \
    chmod a+x $HOME/temp/*.sh; \
    $HOME/temp/rbenv-install.sh git-clone; \
    $HOME/temp/rbenv-install.sh install-plugin; \
    $HOME/temp/rbenv-install.sh prepare-bashrc; \
    $HOME/temp/nvm-install.sh;"

# download, setup & install specified ruby & node version
# install additional packages:
#  - bundler via gem (ruby)
#  - dpl via gaem (ruby)
#  - docker-manifest via npm (node)
RUN bash -l -c "\
    source $HOME/.bashrc; \
    $HOME/temp/setup.sh rbenv ${TARGET_RUBY_VERSION}; \
    $HOME/temp/setup.sh nvm; \
    $HOME/temp/setup.sh packages;"

# print summary of all available binaries & their versions
# clean up and remove build/setup files
RUN bash -l -c "$HOME/temp/summary.sh; rm -rf $HOME/temp/;"

# allow custom data to be mounted into $HOME/build
VOLUME [ "/home/appuser/build" ]

# setting some environment variables (exposed, use with care)
ENV BASH_ENV "/home/appuser/.bashrc"
ENV NVM_DIR "/home/appuser/.nvm"

ENTRYPOINT [ "/usr/local/bin/dumb-init", "--" ]
CMD [ "./docker-entrypoint.sh", "/usr/local/bin/docker", "version" ]
