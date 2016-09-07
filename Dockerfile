FROM openjdk:8-jre-alpine
MAINTAINER Bram van Dartel <root@rootrulez.com>

ARG customerid
ARG password

ENV version 5.5.3
ENV root /opt/xldeploy
ENV home ${root}/xl-deploy-${version}-server
ENV cli_home ${root}/xl-deploy-${version}-cli

RUN  apk update \
 &&  apk add ca-certificates wget \
 &&  update-ca-certificates \
 &&  mkdir -p ${root}

RUN  wget https://${customerid}:${password}@dist.xebialabs.com/customer/xl-deploy/server/${version}/xl-deploy-${version}-server.zip -O /tmp/xl-deploy-server.zip \
 &&  wget https://${customerid}:${password}@dist.xebialabs.com/customer/xl-deploy/server/${version}/xl-deploy-${version}-cli.zip -O /tmp/xl-deploy-cli.zip \
 &&  wget https://${customerid}:${password}@dist.xebialabs.com/customer/licenses/${customerid}/v3/deployit-license.lic -O /tmp/deployit-license.lic \
 &&  unzip /tmp/xl-deploy-server.zip -d ${root} \
 &&  unzip /tmp/xl-deploy-cli.zip -d ${root} \
 &&  cp /tmp/deployit-license.lic ${home}/conf

RUN rm -R /tmp/xl-deploy-server.zip /tmp/xl-deploy-cli.zip /tmp/deployit-license.lic ${home}/samples ${home}/importablePackages/*

ADD xldeploy.answers ${home}/bin/xldeploy.answers

WORKDIR ${home}/bin
RUN ["./run.sh", "-setup", "-reinitialize", "-force", "-setup-defaults", "./bin/xldeploy.answers"]

VOLUME ["${home}/conf", "${home}/ext", "${home}/hotfix", "${home}/importablePackages", "${home}/log", "${home}/plugins", "${home}/repository"]

EXPOSE 4516

CMD ["./run.sh"]
