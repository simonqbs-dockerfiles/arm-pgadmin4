FROM hypriot/rpi-alpine:3.5

ENV PGADMIN_VERSION=1.3 \
    PYTHONDONTWRITEBYTECODE=1

RUN \
	apk add --no-cache python postgresql-dev

RUN \
	apk add --no-cache --virtual .build-deps python-dev py-pip alpine-sdk \
	&& echo "https://ftp.postgresql.org/pub/pgadmin3/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" > requirements.txt \	
	&& pip install --no-cache-dir -r requirements.txt \
	&& rm requirements.txt \
	&& apk del .build-deps

RUN \
	addgroup -g 50 -S pgadmin \
	&& adduser -D -S -h /pgadmin -s /sbin/nologin -u 1000 -G pgadmin pgadmin \
	&& mkdir -p /pgadmin/config /pgadmin/storage \
 	&& chown -R 1000:50 /pgadmin

EXPOSE 5050

COPY LICENSE config_local.py /usr/lib/python2.7/site-packages/pgadmin4/

USER pgadmin:pgadmin
CMD [ "python", "./usr/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py" ]
VOLUME /pgadmin/
