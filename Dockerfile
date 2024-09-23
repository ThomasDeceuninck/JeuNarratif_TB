from node:16-alpine

# workdir /app

run npm install -g expo-cli@5.4.4

cmd ["npm", "start"]