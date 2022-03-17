FROM node:16-alpine3.11 as builder

WORKDIR /app

# install libraries first to least often modified files first
COPY package*.json ./
RUN npm i

# copy and build source files last
COPY . .
RUN npm run build

FROM builder as development

WORKDIR /app

COPY --from=builder /app /app

CMD ["npm", "run", "start:dev"]

FROM node:16-slim as production

WORKDIR /app

COPY --from=builder /app/dist /app/dist

CMD ["node", "./dist/main.js"]
