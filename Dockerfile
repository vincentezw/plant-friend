  FROM ruby:3.2.1-alpine
  RUN apk add \
    build-base \
    mariadb-dev \
    tzdata \
    nodejs \
    yarn \
    imagemagick

  WORKDIR /app
  COPY Gemfile* ./
  RUN bundle install
  RUN yarn global add esbuild sass
  COPY . .
  RUN bundle exec rake assets:precompile RAILS_ENV=production
  EXPOSE 3200
  CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production", "-p", "3200"]
