from bitnami/express:latest

workdir /app
copy package*.json .
run npm install

copy *.js .

EXPOSE 3001

cmd ["node", "index.js"]