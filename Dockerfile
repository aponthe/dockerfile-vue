FROM quay.io/almalinuxorg/9-minimal


#INSTALLING NODE

ENV VERSION_NODE=v18.19.1

ENV OS_NODE=linux

ENV ARCHITECTURE_NODE=arm64

ENV FULL_NAME_NODE=node-${VERSION_NODE}-${OS_NODE}-${ARCHITECTURE_NODE}

ENV PACKAGE_NODE=${FULL_NAME_NODE}.tar.xz

ENV NODE_URL=https://nodejs.org/dist/${VERSION_NODE}/${PACKAGE_NODE}

ENV WORKDIR=/opt/

ENV VUE_PROJECT_PATH=${WORKDIR}/vue/app

WORKDIR ${WORKDIR}

#if addgroup doesnt exists you can install with following command
RUN microdnf install -y shadow-utils

RUN microdnf install -y wget tar xz

#CLEANING CACHE  CONTAINER

RUN microdnf clean all

RUN wget ${NODE_URL}

RUN tar -xf ${PACKAGE_NODE}

#SETTING USER AND GROUP nodejs

RUN groupadd -r nodejs

RUN useradd -r -g nodejs -m -d /home/nodejs nodejs 

RUN chown -R nodejs:nodejs ${WORKDIR}/${FULL_NAME_NODE}

#UPLOADING PROJECT

RUN mkdir -p ${VUE_PROJECT_PATH}

COPY APP/vue-project/. ${VUE_PROJECT_PATH}

RUN chown -R nodejs:nodejs ${VUE_PROJECT_PATH}

USER nodejs

ENV PATH="${WORKDIR}/${FULL_NAME_NODE}/bin:$PATH"

RUN echo ${WORKDIR}
RUN echo ${PACKAGE_NODE}

RUN echo ${PATH}

RUN npm install -g http-server

#UPLOADING APP VUE

WORKDIR ${VUE_PROJECT_PATH}

RUN npm install

RUN ls .

RUN npm run build

EXPOSE 8080

CMD [ "http-server", "dist" ]