FROM hashicorp/vault-enterprise:1.4.2_ent
#RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
#COPY ./ca.pem /usr/local/share/ca-certificates/myca.crt
#RUN update-ca-certificates
COPY vault /bin/vault
RUN chmod a+x /bin/vault
