#!/bin/bash

# Script de Comandos Docker - Aplicação DevOps Petronio Silva
# Conta Docker: ppsfafire

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

# Função para mostrar ajuda
show_help() {
    echo "🐳 Comandos Docker - Aplicação DevOps Petronio Silva"
    echo ""
    echo "Uso: ./docker-commands.sh [comando]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  build     - Build das imagens Docker"
    echo "  up        - Iniciar containers"
    echo "  down      - Parar containers"
    echo "  restart   - Reiniciar containers"
    echo "  logs      - Ver logs dos containers"
    echo "  status    - Status dos containers"
    echo "  clean     - Limpar containers e imagens"
    echo "  push      - Push das imagens para Docker Hub"
    echo "  pull      - Pull das imagens do Docker Hub"
    echo "  test      - Testar aplicação"
    echo "  help      - Mostrar esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  ./docker-commands.sh build"
    echo "  ./docker-commands.sh up"
    echo "  ./docker-commands.sh logs"
}

# Função para build das imagens
build_images() {
    print_status "Construindo imagens Docker..."
    
    # Build backend
    print_status "Build do backend..."
    docker build -t ppsfafire/devops-backend:latest ./backend
    
    # Build frontend
    print_status "Build do frontend..."
    docker build -t ppsfafire/devops-frontend:latest ./frontend
    
    print_success "Imagens construídas com sucesso!"
    
    # Listar imagens
    echo ""
    print_status "Imagens disponíveis:"
    docker images | grep ppsfafire
}

# Função para iniciar containers
start_containers() {
    print_status "Iniciando containers..."
    docker-compose up -d
    
    print_success "Containers iniciados!"
    print_status "Aguardando inicialização..."
    sleep 5
    
    # Verificar status
    check_status
}

# Função para parar containers
stop_containers() {
    print_status "Parando containers..."
    docker-compose down
    print_success "Containers parados!"
}

# Função para reiniciar containers
restart_containers() {
    print_status "Reiniciando containers..."
    docker-compose restart
    print_success "Containers reiniciados!"
}

# Função para ver logs
show_logs() {
    print_status "Mostrando logs dos containers..."
    docker-compose logs -f
}

# Função para verificar status
check_status() {
    print_status "Status dos containers:"
    docker-compose ps
    
    echo ""
    print_status "Testando conectividade..."
    
    # Testar backend
    if curl -s http://localhost:3001/api/health > /dev/null; then
        print_success "✅ Backend funcionando: http://localhost:3001"
    else
        print_error "❌ Backend não está respondendo"
    fi
    
    # Testar frontend
    if curl -s -I http://localhost:80 | grep "200 OK" > /dev/null; then
        print_success "✅ Frontend funcionando: http://localhost:80"
    else
        print_error "❌ Frontend não está respondendo"
    fi
}

# Função para limpar
clean_docker() {
    print_warning "Limpando containers e imagens..."
    
    # Parar e remover containers
    docker-compose down --rmi all --volumes --remove-orphans
    
    # Remover imagens
    docker rmi ppsfafire/devops-backend:latest 2>/dev/null || true
    docker rmi ppsfafire/devops-frontend:latest 2>/dev/null || true
    
    print_success "Limpeza concluída!"
}

# Função para push das imagens
push_images() {
    print_status "Fazendo push das imagens para Docker Hub..."
    
    # Login no Docker Hub (se necessário)
    if ! docker info | grep "Username" > /dev/null; then
        print_warning "Faça login no Docker Hub primeiro:"
        echo "docker login"
        return 1
    fi
    
    # Push das imagens
    docker push ppsfafire/devops-backend:latest
    docker push ppsfafire/devops-frontend:latest
    
    print_success "Push concluído!"
}

# Função para pull das imagens
pull_images() {
    print_status "Fazendo pull das imagens do Docker Hub..."
    
    docker pull ppsfafire/devops-backend:latest
    docker pull ppsfafire/devops-frontend:latest
    
    print_success "Pull concluído!"
}

# Função para testar aplicação
test_application() {
    print_status "Testando aplicação..."
    
    # Testar backend
    echo "🔍 Testando backend..."
    curl -s http://localhost:3001/api/health | jq . 2>/dev/null || curl -s http://localhost:3001/api/health
    
    echo ""
    echo "🔍 Testando frontend..."
    curl -s -I http://localhost:80 | head -1
    
    echo ""
    print_success "Testes concluídos!"
}

# Verificar se Docker está rodando
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker não está rodando. Inicie o Docker Desktop primeiro."
        exit 1
    fi
}

# Main script
case "$1" in
    "build")
        check_docker
        build_images
        ;;
    "up")
        check_docker
        start_containers
        ;;
    "down")
        check_docker
        stop_containers
        ;;
    "restart")
        check_docker
        restart_containers
        ;;
    "logs")
        check_docker
        show_logs
        ;;
    "status")
        check_docker
        check_status
        ;;
    "clean")
        check_docker
        clean_docker
        ;;
    "push")
        check_docker
        push_images
        ;;
    "pull")
        check_docker
        pull_images
        ;;
    "test")
        check_docker
        test_application
        ;;
    "help"|"")
        show_help
        ;;
    *)
        print_error "Comando inválido: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
