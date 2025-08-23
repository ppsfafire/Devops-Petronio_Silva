#!/bin/bash

# Script de Setup - Aplicação DevOps Petronio Silva
echo "🚀 Configurando Aplicação DevOps - Petronio Silva"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se Git está instalado
if ! command -v git &> /dev/null; then
    print_error "Git não está instalado. Por favor, instale o Git primeiro."
    exit 1
fi

# Verificar se Node.js está instalado
if ! command -v node &> /dev/null; then
    print_warning "Node.js não está instalado. A aplicação pode não funcionar corretamente."
fi

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    print_warning "Docker não está instalado. A containerização não funcionará."
fi

print_status "Inicializando repositório Git..."

# Inicializar repositório Git
git init

# Adicionar remote origin
git remote add origin https://github.com/ppsfafire/Devops-Petronio_Silva.git

print_status "Configurando branches..."

# Criar e configurar branches
git checkout -b dev
git checkout -b staging
git checkout -b master

# Voltar para dev como branch padrão
git checkout dev

print_status "Instalando dependências..."

# Instalar dependências
if command -v npm &> /dev/null; then
    npm run install:all
    print_success "Dependências instaladas com sucesso!"
else
    print_warning "npm não encontrado. Instale as dependências manualmente."
fi

print_status "Configurando Git hooks..."

# Criar diretório para hooks
mkdir -p .git/hooks

# Criar pre-commit hook básico
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "🔍 Executando pre-commit checks..."

# Verificar sintaxe do código
echo "Verificando sintaxe..."
if command -v node &> /dev/null; then
    cd backend && node -c server.js && cd ..
    cd frontend && npm run build --silent && cd ..
fi

echo "✅ Pre-commit checks concluídos!"
EOF

chmod +x .git/hooks/pre-commit

print_status "Criando arquivo .env de exemplo..."

# Criar arquivo .env de exemplo
cat > .env.example << 'EOF'
# Configurações do Backend
NODE_ENV=development
PORT=3001

# Configurações do Frontend
REACT_APP_API_URL=http://localhost:3001

# Configurações AWS (para produção)
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
EOF

print_status "Configurando Docker..."

# Verificar se Docker está disponível
if command -v docker &> /dev/null; then
    print_status "Testando Docker..."
    docker --version
    print_success "Docker configurado!"
else
    print_warning "Docker não está disponível. Configure manualmente."
fi

print_status "Criando primeiro commit..."

# Adicionar todos os arquivos
git add .

# Fazer primeiro commit
git commit -m "🎉 Initial commit: Aplicação DevOps completa

- Frontend React com tema claro
- Backend Node.js/Express
- Docker containers
- GitHub Actions CI/CD
- Infraestrutura AWS com Terraform
- Documentação completa"

print_success "✅ Setup concluído com sucesso!"

echo ""
echo "📋 Próximos passos:"
echo "1. Configure suas credenciais AWS"
echo "2. Adicione secrets no GitHub:"
echo "   - AWS_ACCESS_KEY_ID"
echo "   - AWS_SECRET_ACCESS_KEY"
echo "3. Execute: git push -u origin dev"
echo "4. Para testar localmente: npm run dev"
echo "5. Para testar com Docker: docker-compose up --build"
echo ""
echo "🔗 Repositório: https://github.com/ppsfafire/Devops-Petronio_Silva.git"
echo "📖 Documentação: README.md"
echo ""
print_success "🚀 Aplicação DevOps pronta para uso!"
