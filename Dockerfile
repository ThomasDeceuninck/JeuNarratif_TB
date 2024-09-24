# from node:16-alpine
# workdir /app
# run npm install -g expo-cli@5.4.4
# cmd ["npm", "start"]

#     pull base image

FROM node:latest

    # set our node environment, either development or production
    # defaults to production, compose overrides this to development on build and run

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

    # default to port 19006 for node, and 19001 and 19002 (tests) for debug

ARG PORT=19006
ENV PORT $PORT
EXPOSE 19006 19001 19002 19000

    # add in your own IP that was assigned by EXPO for your local machine

ENV REACT_NATIVE_PACKAGER_HOSTNAME="172.19.0.4"

    # install global packages

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH /home/node/.npm-global/bin:$PATH
RUN npm i --unsafe-perm -g npm@latest expo-cli@latest
RUN apt-get update && apt-get install -y qemu-user-static

    # We need to install this inorder to start a tunnel on the docker conatiner

RUN yarn add @expo/ngrok

    # install dependencies first, in a different location for easier app bind mounting for local development
    # due to default /opt permissions we have to create the dir with root and change perms

RUN mkdir /opt/my-app && chown root:root /opt/my-app
WORKDIR /opt/my-app
ENV PATH /opt/my-app/.bin:$PATH
USER root
COPY package.json package-lock.json app.json ./
RUN yarn install

    # ajout selon demande des logs

RUN npx expo install react-dom@18.2.0 react-native@0.71.14 react-native-svg@13.4.0


    #copy in our source code last, as it changes the most

WORKDIR /opt/my-app

    #for development, we bind mount volumes; comment out for production

COPY . /opt/my-app/

RUN npx expo install react-native-screens react-native-safe-area-context
CMD ["npm","run","web"]

#---------------------------------------------------------


    # FROM ubuntu:20.04

    # ARG DEBIAN_FRONTEND=noninteractive
    
    # RUN apt-get update && \
    #   apt-get install -yq curl && \
    #   curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    #   apt-get install -y nodejs
    
    # COPY . /home/
    # WORKDIR /home
    
    # RUN npm install chokidar && npm install -g expo-cli && npm i -g yarn
    # RUN npm install
    # CMD [ "npm", "expo --web" ]