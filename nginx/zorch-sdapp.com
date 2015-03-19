upstream sdapp {
        server 127.0.0.1:58080;
}

server {
  listen 0.0.0.0:80;
  server_name sdapp.com;
  access_log /var/log/nginx/sdapp.access;

  location / {
    proxy_pass http://sdapp/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $http_host;

    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forward-Proto http;
    proxy_set_header X-Nginx-Proxy true;

    proxy_redirect off;
  }
}