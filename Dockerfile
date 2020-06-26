FROM ubuntu:16.04

# 80 = HTTP, 443 = HTTPS, 3000 = MEAN.JS server, 35729 = livereload, 8080 = node-inspector
EXPOSE 80 3000

# Install Utilities
RUN apt-get update -q  \
 && apt-get install -yqq \
 curl \
 git \
 ssh \
 gcc \
 make \
 build-essential \
 libkrb5-dev \
 sudo \
 vim \
 net-tools \
 apt-utils \
 supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN sudo apt-get install -yq nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install and copy Nginx
RUN apt-get update \
    && apt-get install -y nginx \
    && sudo rm -r /etc/nginx/nginx.conf

#COPY default /etc/nginx/sites-enabled/
COPY nginx.conf /etc/nginx/

# Copy supervisord conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy start script
COPY start.sh /

# Node deployment steps
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force
COPY . /usr/src/app
#RUN npm run build:ssr    [change as per your app's build step]


CMD [ "/bin/sh", "/start.sh" ]
