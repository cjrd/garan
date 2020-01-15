FROM silex/emacs:27.0

# ==================================================================
# === Don't mess with this section or install anything before it ===
# ==================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# =======================
# === System Packages ===
# =======================
# Don't be a slob, keep it sorted!
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    dpkg-sig \
    figlet \
    fonts-liberation \
    gcc \
    gconf-service \
    gdb \
    ggcov \
    git \
    gnutls-bin \
    imagemagick \
    inotify-tools \
    iproute2 \
    jq \
    language-pack-en \
    less \
    libappindicator1 \
    libasound2 \
    libatk1.0-0 \
    libc6-dev \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgnutls28-dev \
    libgtk-3-0 \
    libncurses-dev \ 
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libssl-dev \
    libstdc++6 \
    libudev-dev \
    libusb-1.0-0-dev \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    locate \
    lsb-release \
    lsof \
    make \
    nmap \
    openssh-server \
    python-pip \
    python2.7-dev \
    python3.6-dev \
    rsync \
    ruby-dev \
    rubygems-integration \
    shellcheck \
    tmux \
    tree \
    unzip \
    usbutils \
    wget \
    xdg-utils \
    xsltproc \
    zip \
    zlib1g-dev \
    zsh

# ================
# === POSTGRES ===
# ================
ENV PG_APP_HOME="/etc/docker-postgresql"\
    PG_VERSION=9.6 \
    PG_USER=postgres \
    PG_HOME=/var/lib/postgresql \
    PG_RUNDIR=/run/postgresql \
    PG_LOGDIR=/var/log/postgresql \
    PG_CERTDIR=/etc/postgresql/certs

ENV PG_BINDIR=/usr/lib/postgresql/${PG_VERSION}/bin \
    PG_DATADIR=${PG_HOME}/${PG_VERSION}/main

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y acl \
      postgresql-${PG_VERSION} postgresql-client-${PG_VERSION} postgresql-contrib-${PG_VERSION} \
 && rm -rf /var/lib/apt/lists/*

VOLUME ["${PG_HOME}", "${PG_RUNDIR}"]

COPY scripts/start-psql.sh /root

# Setup the basic locale system
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

# ===========
# === zsh ===
# ===========
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# ==============
# === Docker ===
# ==============
# https://github.com/docker/docker/issues/17935
RUN curl -sSL https://get.docker.com/ | sh

# ==========
# === Go ===
# ==========
# Note that these ENVs get exported to child Docker containers.
ENV LC_ALL en_US.UTF-8
ENV GOPATH /go:/gothirdparty
ENV PATH /go/bin:/usr/local/go/bin:/gothirdparty/bin:$PATH
ENV GOLANG_VERSION 1.13.5
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 512103d7ad296467814a6e3f635631bd35574cab3369a97a323c9a585ccaa569
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz
# Go development helpers (versioning is not essential as these tools only
# assist with developement, e.g. autocompletions)
RUN go get -u -v github.com/githubnemo/CompileDaemon
RUN go get -u -v github.com/DotDashPay/overalls
RUN go get -u -v github.com/kyoh86/richgo
RUN go get -u -v github.com/nsf/gocode
RUN go get -u -v github.com/rogpeppe/godef
RUN go get -u -v golang.org/x/tools/cmd/goimports
RUN go get -u -v golang.org/x/tools/cmd/gorename
RUN go get -u github.com/derekparker/delve/cmd/dlv

# ============
# === Node ===
# ============
ENV NODE_VERSION 10.16.0
ENV NPM_VERSION 6.9.0
RUN mkdir -p /root/.node-gyp
RUN mkdir -p /root/.npm

# Install n and node
ENV N_PREFIX /root/n
RUN curl -L https://git.io/n-install | bash -s -- -q $NODE_VERSION
RUN cd /usr/local/bin && ln -s /root/n/bin/* .

# Update npm.
RUN npm install --global npm@$NPM_VERSION

# ==============
# === Python ===
# ==============
RUN pip install --upgrade pip setuptools
# protobuf added python wheel files that don't install the `google.protobuf.compiler` package;
# --no-binary :all: skips the wheel files and builds this package.
RUN pip install --no-binary :all: 'protobuf==3.0.0'
COPY requirements.txt /root/setup/requirements.txt
RUN pip install -r /root/setup/requirements.txt

# rg
RUN cd /tmp \
 && wget https://github.com/BurntSushi/ripgrep/releases/download/0.7.1/ripgrep-0.7.1-i686-unknown-linux-musl.tar.gz \
 && tar -xvf ripgrep-0.7.1-i686-unknown-linux-musl.tar.gz \
 && cp ripgrep-0.7.1-i686-unknown-linux-musl/rg /usr/local/bin \
 && cd -


# ===============
# === Cleanup ===
# ===============
RUN updatedb


# =============================
# == Ruby Installs for Docs  ==
# =============================
RUN gem install bundle

# =============================
# ====== Typescript Biz  ======
# =============================
RUN npm install -g typescript@3.5.2 && ln -s /root/n/bin/tsc /usr/local/bin/tsc
RUN npm install --ignore-scripts --global semver
RUN npm install -g gnomon && ln -s /root/n/bin/gnomon /usr/local/bin/gnomon
RUN npm install -g jsonlint@1.6.3
RUN npm install -g ts-node && ln -s /root/n/bin/ts-node /usr/local/bin/ts-node
ENV PATH $PATH:/root/n/bin


# we work in the kondo in our garan
WORKDIR /root/kondo

