FROM node:18-alpine as builder
WORKDIR /to-do-app
ENV NODE_OPTIONS "--openssl-legacy-provider"
COPY package.json .
COPY yarn.lock .
RUN yarn upgrade
COPY . .
RUN yarn build

FROM nginx:1.19.0
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /to-do-app/build .
ENTRYPOINT ["nginx","-g","daemon off;"]