# pull official base image
FROM node:16-alpine3.15

RUN apk add curl
# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
#ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies

COPY package.json ./
COPY yarn.lock ./

#RUN yarn global add react-scripts@5.0.1 

# add app

COPY . ./
RUN yarn install
#EXPOSE 3000
EXPOSE 443
#ENV PORT 3000
ENV HTTPS true

# start app
CMD ["yarn", "start"]
#CMD ["ls", "/app/node_modules/.bin", "-lr"]
