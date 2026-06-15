FROM ruby:3.1-slim

RUN apt-get update -qq && apt-get install -y \
    curl \
    unzip \
    git \
    parallel \
    build-essential \
    libsqlite3-dev \
    libxml2-dev \
    libxslt-dev \
    python3 \
    python3-pip \
    jq \
    wget \
    nodejs \
    npm \
    gdal-bin \
    libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy files from the current directory. Files listed in .dockerignore will be excluded.
COPY . /app

# for tasks
RUN bundle install --without development test

# for tippecanoe
RUN git clone https://github.com/felt/tippecanoe.git && \
    cd tippecanoe && \
    make -j && \
    make install && \
    cd .. && \
    rm -rf tippecanoe

# for mojxml2geojson
RUN pip install --break-system-packages git+https://github.com/digital-go-jp/mojxml2geojson.git

# for mojxml-rs (Rust frontend; default conversion path)
ARG MOJXML_RS_VERSION=v0.3.0
RUN wget https://github.com/KotobaMedia/mojxml-rs/releases/download/${MOJXML_RS_VERSION}/mojxml-rs-x86_64-unknown-linux-gnu.zip \
    && unzip mojxml-rs-x86_64-unknown-linux-gnu.zip \
    && mv mojxml-rs /usr/local/bin/ \
    && chmod +x /usr/local/bin/mojxml-rs \
    && rm mojxml-rs-x86_64-unknown-linux-gnu.zip

# for go-pmtiles
RUN wget https://github.com/protomaps/go-pmtiles/releases/download/v1.26.1/go-pmtiles_1.26.1_Linux_x86_64.tar.gz \
    && tar xvf go-pmtiles_1.26.1_Linux_x86_64.tar.gz \
    && mv pmtiles /usr/local/bin/

# for unvt/charites
RUN npm install -g @unvt/charites
RUN git clone https://github.com/optgeo/optbv-intl.git
RUN ln -s optbv-intl/layers /app/layers

# for budo
RUN npm install -g budo
