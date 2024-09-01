FROM node:alpine AS builder
WORKDIR /app
COPY ./package*.json ./
RUN npm ci
COPY ./tsconfig.json .
COPY ./src ./src
RUN npm run build

FROM node:alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["npm", "run", "start"]