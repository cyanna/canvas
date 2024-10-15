# Ensure Tini runs as PID 1
ENTRYPOINT ["/tini", "--", "/usr/src/entrypoint"]

# Fix sudo permissions
RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

# Rest of your Dockerfile
ARG RUBY=3.3

FROM instructure/ruby-passenger:$RUBY
LABEL maintainer="Instructure"

ARG RUBY
ARG POSTGRES_CLIENT=14
ENV APP_HOME /usr/src/app/
ENV RAILS_ENV development
ENV NGINX_MAX_UPLOAD_SIZE 10g
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ARG CANVAS_RAILS=7.1
ENV CANVAS_RAILS=${CANVAS_RAILS}

ENV NODE_MAJOR 18
ENV YARN_VERSION 1.19.1-1
ENV GEM_HOME /home/docker/.gem/$RUBY
ENV PATH ${APP_HOME}bin:$GEM_HOME/bin:$PATH
ENV BUNDLE_APP_CONFIG /home/docker/.bundle

WORKDIR $APP_HOME

USER root

ARG USER_ID
RUN if [ -n "$USER_ID" ]; then usermod -u "${USER_ID}" docker \
  && chown --from=9999 docker /usr/src/nginx /usr/src/app -R; fi

RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && printf 'path-exclude /usr/share/doc/*\npath-exclude /usr/share/man/*' > /etc/dpkg/dpkg.cfg.d/01_nodoc \
  && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && add-apt-repository ppa:git-core/ppa -ny \
  && apt-get update -qq \
  && apt-get install -qqy --no-install-recommends \
  nodejs \
  yarn="$YARN_VERSION" \
  libxmlsec1-dev \