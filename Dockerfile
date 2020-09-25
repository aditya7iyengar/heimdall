FROM bitwalker/alpine-elixir:1.10.4

# Install NPM
RUN \
    mkdir -p /opt/app && \
    chmod -R 777 /opt/app && \
    apk update && \
    apk --no-cache --update add \
      make \
      g++ \
      wget \
      curl \
      inotify-tools \
      nodejs \
      nodejs-npm && \
    npm install npm -g --no-progress && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

# Add local node module binaries to PATH
ENV PATH=./node_modules/.bin:$PATH

# Ensure latest versions of Hex/Rebar are installed on build
ONBUILD RUN mix do local.hex --force, local.rebar --force

WORKDIR /opt/app

COPY . .

RUN mix deps.get

RUN cd apps/bifrost/assets && npm install

ENV BIFROST_PORT 4010
ENV BIFROST_USER dev_user
ENV BIFROST_PASSWORD secret

CMD ["mix", "phx.server"]
