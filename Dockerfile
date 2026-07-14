FROM ruby:3.0

# System deps Jekyll commonly needs (nokogiri, etc.)
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only the dependency manifests first.
# This layer is cached and only rebuilds when Gemfile/Gemfile.lock change,
# so gems aren't reinstalled on every code change.
COPY Gemfile Gemfile.lock ./

RUN bundle install

# Now copy the rest of the site.
WORKDIR /app

EXPOSE 4000

# Bind to 0.0.0.0 so the port is reachable from the host
CMD ["bundle", "exec", "jekyll", "serve", "--watch", "--incremental", "--host", "0.0.0.0", \
     "--config", "_config.yml,_versions.yml"]