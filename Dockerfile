FROM ruby:2.6.3

RUN apt-get update -yqq 

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# RUN apt-cache show nodejs

RUN apt-get install -yqq nodejs
RUN apt-get install -yqq yarn

RUN node --version
RUN npm --version
RUN yarn --version

RUN apt-get install -yqq build-essential postgresql-client
RUN mkdir -p /usr/local/nvm

RUN mkdir -p /usr/local/nvm
RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
RUN bundle install --verbose --jobs 20 --retry 5

RUN npm install -g yarn
RUN yarn install --check-files

COPY . ./

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
