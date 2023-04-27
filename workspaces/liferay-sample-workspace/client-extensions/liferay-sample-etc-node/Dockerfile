FROM liferay/node-runner:latest

COPY package.json /opt/liferay

RUN npm install

COPY *.js config.json /opt/liferay/
COPY util/ /opt/liferay/util/