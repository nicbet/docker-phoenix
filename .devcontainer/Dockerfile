FROM nicbet/phoenix:1.6.11

RUN apt-get install -y ruby \
  && gem install --no-document htmlbeautifier -v 1.3.1 \
  && npm i -g yarn \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
