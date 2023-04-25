FROM liferay/node-runner:latest

COPY app.js package.json /opt/liferay/
COPY util/ /opt/liferay/util/

RUN npm install