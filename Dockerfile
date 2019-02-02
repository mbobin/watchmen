FROM ruby:2.6-alpine as builder

WORKDIR /watchmen

RUN apk add --no-cache build-base

COPY Gemfile* ./
RUN bundle install --without test
COPY . .


FROM ruby:2.6-alpine

WORKDIR /watchmen
COPY --from=builder /watchmen /watchmen
COPY --from=builder /usr/local/bundle /usr/local/bundle

RUN bundle install --without test --local

CMD [ "ruby", "app/application.rb" ]
