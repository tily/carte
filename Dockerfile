FROM phusion/passenger-customizable:latest
CMD ["/sbin/my_init"]

# install ruby and node.js
RUN /pd_build/ruby2.2.sh
RUN /pd_build/nodejs.sh

## configure nginx
RUN rm /etc/nginx/sites-enabled/default
ADD nginx.conf /etc/nginx/sites-enabled/carte.conf

## add source code
RUN mkdir /home/app/carte
ADD . /home/app/carte

## install dependencies
RUN npm install gulp -g
RUN cd /home/app/carte && bundle install
RUN cd /home/app/carte && npm install

## build client side code
RUN cd /home/app/carte && gulp build

## cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## enable nginx
RUN rm -f /etc/service/nginx/down
