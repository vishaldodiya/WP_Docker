docker run --name nginx-proxy --restart always -d -p 80:80 -p 443:443 \
    -v ~/.ee4/etc/nginx/certs:/etc/nginx/certs \
    -v ~/.ee4/etc/nginx/conf.d:/etc/nginx/conf.d \
    -v ~/.ee4/etc/nginx/htpasswd:/etc/nginx/htpasswd \
    -v ~/.ee4/etc/nginx/vhost.d:/etc/nginx/vhost.d \
    -v ~/.ee4/usr/share/nginx/html:/usr/share/nginx/html \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    -v $(pwd)/config/nginx/custom_proxy_settings.conf://etc/nginx/conf.d/custom_proxy_settings.conf \
    jwilder/nginx-proxy

docker run -d --name letsencrypt \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --volumes-from nginx-proxy \
    jrcs/letsencrypt-nginx-proxy-companion

docker network connect waterweasel.xyz nginx-proxy
docker network connect waterweasel.xyz letsencrypt

docker-compose up -d

docker logs nginx-proxy -f
