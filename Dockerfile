FROM kong:3.0.0-alpine

ENV OIDC_PLUGIN_VERSION=1.3.0-3
ENV JWT_PLUGIN_VERSION=1.1.0-1
ENV GIT_VERSION=2.38.1-r0
ENV UNZIP_VERSION=6.0-r13
ENV LUAROCKS_VERSION=2.4.4-r2

USER root
RUN apk update && apk add git=${GIT_VERSION} unzip=${UNZIP_VERSION} luarocks=${LUAROCKS_VERSION}
RUN luarocks install kong-oidc

RUN git clone https://github.com/revomatico/kong-oidc.git
WORKDIR /kong-oidc
RUN luarocks make

RUN luarocks pack kong-oidc ${OIDC_PLUGIN_VERSION} \
     && luarocks install kong-oidc-${OIDC_PLUGIN_VERSION}.all.rock

WORKDIR /
RUN git clone https://github.com/raviverma-ai/kong-plugin-jwt-keycloak.git
WORKDIR /kong-plugin-jwt-keycloak
RUN luarocks make

RUN luarocks pack kong-plugin-jwt-keycloak ${JWT_PLUGIN_VERSION} \
     && luarocks install kong-plugin-jwt-keycloak-${JWT_PLUGIN_VERSION}.all.rock

USER kong
