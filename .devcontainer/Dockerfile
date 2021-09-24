FROM nicbet/phoenix:1.6.0

RUN apt-get install -y ruby \
  && gem install --no-ri --no-rdoc htmlbeautifier \
  && npm i -g yarn \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
