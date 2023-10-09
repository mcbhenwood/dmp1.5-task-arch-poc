FROM nginxinc/nginx-unprivileged

RUN rm -f /etc/nginx/conf.d/*.conf
COPY sites-enabled.conf /etc/nginx/conf.d/sites-enabled.conf
COPY hello-site.conf /etc/nginx/sites-enabled/hello.conf
COPY static /app/static

EXPOSE 8080
