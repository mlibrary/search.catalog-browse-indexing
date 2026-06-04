################################################################################
# DEVELOPMENT
################################################################################
FROM ruby:3.3 AS development

# Check https://rubygems.org/gems/bundler/versions for the latest version.
ARG UID=1000
ARG GID=1000

## Install Vim (optional)
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  vim-tiny


RUN groupadd -g ${GID} -o app
RUN useradd -m -d /app -u ${UID} -g ${GID} -o -s /bin/bash app

ENV GEM_HOME=/gems
ENV PATH="$PATH:/app/exe:/app/bin"
RUN mkdir -p /gems && chown ${UID}:${GID} /gems

ENV BUNDLE_PATH=/app/vendor/bundle

USER app
RUN gem install bundler

WORKDIR /app

################################################################################
# PRODUCTION
################################################################################
FROM development AS production

COPY --chown=${UID}:${GID} . /app

RUN bundle install
