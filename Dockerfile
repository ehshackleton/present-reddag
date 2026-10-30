FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html Presentacion_Soberania_Reveal.html Software_Libre_Cuatro_Libertades_100s.mp4 /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/
COPY assets/ /usr/share/nginx/html/assets/
COPY vendor/ /usr/share/nginx/html/vendor/

EXPOSE 80
