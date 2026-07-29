FROM ruby:3.3.5

# 必要なライブラリのインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

WORKDIR /app

# Gemfileのコピーとインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# entrypoint.sh の設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]