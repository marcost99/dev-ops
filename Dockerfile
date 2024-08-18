#1. configuration for build
#1.0 definies the image the container (with operating system and binaries necessaries for execution of the application)
FROM node:20-slim AS build

#1.1 sets the directory of application in the container
WORKDIR /usr/src/app

#1.2 copies the file with the definitions of the dependencies necessaries
COPY package.json ./

#1.3 install the dependencies
RUN yarn

#1.4 copies the files of the application for the directory of the container
COPY . .

#1.5 makes the build
RUN yarn run build
#RUN yarn workspaces focus --production && yarn cache clean

#2. configuration for execution
#2.0 definies the image the container (with operating system and binaries necessaries for execution of the application)
FROM node:20-alpine3.19

#2.1 sets the directory of application in the container
WORKDIR /usr/src/app

#2.2 copies the files generateds of the build for directory of the container
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

#2.3 exposes the port of the application
EXPOSE 3000

#2.4 initializes the application
CMD ["yarn","run","start:prod"]