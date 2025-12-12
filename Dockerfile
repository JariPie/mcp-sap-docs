FROM node:20-alpine

WORKDIR /app

# Git is required
RUN apk add --no-cache git bash

# Force HTTPS for all GitHub repos
RUN git config --global url."https://github.com/".insteadOf "git@github.com:"

# Clone without recursive submodules
RUN git clone --depth=1 https://github.com/JariPie/mcp-sap-docs.git . \
 && git submodule update --init --depth=1 \
 && cd sources/wdi5 \
 && git submodule update --init --depth=1

RUN npm ci
RUN ./setup.sh
RUN npm run build

EXPOSE 3122
ENV PORT=3122 MCP_PORT=3122 NODE_ENV=production

CMD ["npm", "run", "start:streamable"]
