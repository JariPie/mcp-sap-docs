FROM node:20-alpine

WORKDIR /app

# Install git (needed for submodules)
RUN apk add --no-cache git bash

# Force HTTPS for all GitHub repositories
RUN git config --global url."https://github.com/".insteadOf "git@github.com:"

# Copy repository contents
COPY . .

# Initialize submodules manually (no SSH)
RUN git submodule update --init --depth=1 \
 && cd sources/wdi5 \
 && git submodule update --init --depth=1

# Install dependencies
RUN npm ci

# Prepare docs + build
RUN ./setup.sh
RUN npm run build

ENV PORT=3122
ENV MCP_PORT=3122
ENV NODE_ENV=production

EXPOSE 3122

CMD ["npm", "run", "start:streamable"]
