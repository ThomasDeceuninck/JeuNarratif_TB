from bitnami/express:latest

workdir /app
copy package*.json ./
run npm install

copy *.js .

expose 3001

cmd ["npm", "start"]