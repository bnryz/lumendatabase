FROM docker.io/library/ruby:3.2.2-alpine3.19

RUN apk add --no-cache curl-dev g++ gcc git libpq-dev make musl-dev shared-mime-info
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

FROM docker.io/library/ruby:3.2.2-alpine3.19
RUN apk add --no-cache libpq shared-mime-info tzdata
COPY --from=0 /usr/local/bundle /usr/local/bundle
WORKDIR /srv
COPY . .
CMD ["rails", "s", "-b", "0.0.0.0"]
