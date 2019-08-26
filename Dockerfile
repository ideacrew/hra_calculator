FROM ruby:2.6.3

RUN apt install curl

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# RUN sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

RUN apt-get update -yqq 
RUN apt-get install -yqq nodejs yarn

RUN node --version
RUN npm --version
RUN yarn --version

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
