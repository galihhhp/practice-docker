FROM node:alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:alpine AS runner
WORKDIR /app
COPY --from=builder /app/build .
COPY --from=builder /app/package*.json .
RUN npm install --production
EXPOSE 3000
CMD ["node", "index.js"]
