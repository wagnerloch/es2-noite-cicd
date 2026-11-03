# Estágio 1: Construção da aplicação
FROM node:20-alpine AS builder

# Definir o diretório de trabalho
WORKDIR /app

# Copiar os arquivos de configuração do projeto
COPY package.json package-lock.json tsconfig.json ./

# Instalar as dependências do projeto
RUN npm install

# Copiar o restante dos arquivos do projeto
COPY . .

# Compilar o TypeScript para JavaScript
RUN npm run build

# Estágio 2: Imagem final - Produção
FROM node:20-alpine

# Definir o diretório de trabalho
WORKDIR /app

# Copiar apenas os arquivos necessários da etapa de construção
COPY --from=builder /app/dist ./dist

# Instalar apenas as dependências de produção
COPY package.json package-lock.json ./
RUN npm install --only=production

# Expor a porta que a aplicação irá rodar
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["node", "dist/index.js"]