#!/bin/bash
# Build and push Docker images
# ----------------------------
#
# For simplicity we are only focusing on the Frontend case (it's a superset of the
# API case).
#
set -e
NGINX_TAG=`scripts/core/ecr_repository/get_ecr_repository_uri.py nginx`
UWSGI_TAG=`scripts/core/ecr_repository/get_ecr_repository_uri.py uwsgi`
scripts/core/ecr_repository/get_login_password.py | docker login --username AWS --password-stdin `scripts/core/ecr_repository/get_ecr_registry_uri.py`
docker build -t $NGINX_TAG frontend/nginx
docker build -t $UWSGI_TAG frontend/uwsgi
docker push $NGINX_TAG
docker push $UWSGI_TAG
