#Base off the latest ubuntu release
FROM ubuntu:14.04

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev wget git zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev nodejs

# install Ruby
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
ENV PATH /.rbenv/bin:/.rbenv/shims:$PATH
RUN echo PATH=$PATH
RUN rbenv init -
RUN rbenv install 2.1.2 && rbenv global 2.1.2

# Never install rubygem docs
RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc

# Install bundler
RUN gem install bundler && rbenv rehash

# Add gemfiles early to cache installed gems
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

# Install app rubygem dependencies
RUN bundle install

# Change and link to the app directory
RUN mkdir /app
WORKDIR /app
ADD . /app

RUN ls
RUN pwd
