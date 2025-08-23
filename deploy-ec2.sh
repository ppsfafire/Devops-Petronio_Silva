#!/bin/bash

# Script de Deploy para EC2 - Aplicação DevOps Petronio Silva
# Servidor: ec2-18-117-195-190.us-east-2.compute.amazonaws.com

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações do servidor
EC2_HOST="ec2-18-117-195-190.us-east-2.compute.amazonaws.com"
EC2_IP="18.117.195.190"
EC2_USER="ubuntu"  # ou ec2-user para Amazon Linux
SSH_KEY="~/.ssh/your-key.pem"  # Ajuste para sua chave SSH

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
    echo "🚀 Deploy EC2 - Aplicação DevOps Petronio Silva"
    echo ""
    echo "Uso: ./deploy-ec2.sh [comando]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  setup     - Configurar servidor EC2"
    echo "  build     - Build e push das imagens"
    echo "  deploy    - Deploy da aplicação"
    echo "  update    - Atualizar aplicação"
    echo "  logs      - Ver logs remotos"
    echo "  status    - Status da aplicação"
    echo "  stop      - Parar aplicação"
    echo "  restart   - Reiniciar aplicação"
    echo "  backup    - Backup dos dados"
    echo "  help      - Mostrar esta ajuda"
    echo ""
    echo "Configurações:"
    echo "  Servidor: $EC2_HOST"
    echo "  IP: $EC2_IP"
    echo "  Usuário: $EC2_USER"
    echo "  Chave SSH: $SSH_KEY"
    echo ""
    echo "Exemplos:"
    echo "  ./deploy-ec2.sh setup"
    echo "  ./deploy-ec2.sh deploy"
    echo "  ./deploy-ec2.sh status"
}

# Função para testar conectividade SSH
test_ssh() {
    print_status "Testando conectividade SSH..."
    
    if ssh -i $SSH_KEY -o ConnectTimeout=10 -o BatchMode=yes $EC2_USER@$EC2_IP "echo 'SSH OK'" 2>/dev/null; then
        print_success "✅ Conectividade SSH OK"
        return 0
    else
        print_error "❌ Erro na conectividade SSH"
        print_warning "Verifique:"
        echo "  1. Chave SSH: $SSH_KEY"
        echo "  2. Usuário: $EC2_USER"
        echo "  3. IP: $EC2_IP"
        echo "  4. Security Group (porta 22)"
        return 1
    fi
}

# Função para configurar servidor
setup_server() {
    print_status "Configurando servidor EC2..."
    
    if ! test_ssh; then
        return 1
    fi
    
    # Script de configuração remota
    cat > /tmp/setup-server.sh << 'EOF'
#!/bin/bash

echo "🔧 Configurando servidor EC2..."

# Atualizar sistema
sudo apt-get update -y
sudo apt-get upgrade -y

# Instalar Docker
if ! command -v docker &> /dev/null; then
    echo "📦 Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# Instalar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Instalando Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Criar diretório da aplicação
sudo mkdir -p /opt/devops-app
sudo chown $USER:$USER /opt/devops-app

# Configurar firewall (se necessário)
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 3001/tcp
sudo ufw --force enable

echo "✅ Configuração do servidor concluída!"
EOF

    # Executar script remoto
    scp -i $SSH_KEY /tmp/setup-server.sh $EC2_USER@$EC2_IP:/tmp/
    ssh -i $SSH_KEY $EC2_USER@$EC2_IP "chmod +x /tmp/setup-server.sh && /tmp/setup-server.sh"
    
    print_success "✅ Servidor configurado!"
}

# Função para build e push das imagens
build_images() {
    print_status "Build e push das imagens Docker..."
    
    # Build local
    ./docker-commands.sh build
    
    # Login no Docker Hub
    print_status "Login no Docker Hub..."
    docker login
    
    # Push das imagens
    ./docker-commands.sh push
    
    print_success "✅ Imagens enviadas para Docker Hub!"
}

# Função para deploy
deploy_app() {
    print_status "Fazendo deploy da aplicação..."
    
    if ! test_ssh; then
        return 1
    fi
    
    # Criar docker-compose.yml remoto
    cat > /tmp/docker-compose-ec2.yml << 'EOF'
version: '3.8'

services:
  backend:
    image: ppsfafire/devops-backend:latest
    container_name: devops-backend
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - PORT=3001
    restart: unless-stopped
    networks:
      - devops-network

  frontend:
    image: ppsfafire/devops-frontend:latest
    container_name: devops-frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    environment:
      - REACT_APP_API_URL=http://18.117.195.190:3001
    restart: unless-stopped
    networks:
      - devops-network

networks:
  devops-network:
    driver: bridge
EOF

    # Enviar arquivo para servidor
    scp -i $SSH_KEY /tmp/docker-compose-ec2.yml $EC2_USER@$EC2_IP:/opt/devops-app/docker-compose.yml
    
    # Executar deploy
    ssh -i $SSH_KEY $EC2_USER@$EC2_IP "cd /opt/devops-app && docker-compose pull && docker-compose up -d"
    
    print_success "✅ Deploy concluído!"
    print_status "Aplicação disponível em:"
    echo "  🌐 Frontend: http://$EC2_IP"
    echo "  🔧 Backend: http://$EC2_IP:3001"
    echo "  📊 Health: http://$EC2_IP:3001/api/health"
}

# Função para atualizar aplicação
update_app() {
    print_status "Atualizando aplicação..."
    
    if ! test_ssh; then
        return 1
    fi
    
    ssh -i $SSH_KEY $EC2_USER@$EC2_IP "cd /opt/devops-app && docker-compose pull && docker-compose up -d"
    
    print_success "✅ Aplicação atualizada!"
}

# Função para ver logs
show_logs() {
    print_status "Mostrando logs da aplicação..."
    
    if ! test_ssh; then
        return 1
    fi
    
    ssh -i $SSH_KEY $EC2_USER@$EC2_IP "cd /opt/devops-app && docker-compose logs -f"
}

# Função para verificar status
check_status() {
    print_status "Verificando status da aplicação..."
    
    if ! test_ssh; then
        return 1
    fi
    
    # Status dos containers
    ssh -i $SSH_KEY $EC2_USER@$EC2_IP "cd /opt/devops-app && docker-compose ps"
    
    echo ""
    print_status "Testando conectividade..."
    
    # Testar backend
    if curl -s http://$EC2_IP:3001/api/health > /dev/null; then
        print_success "✅ Backend funcionando: http://$EC2_IP:3001"
    else
        print_error "❌ Backend não está respondendo"
    fi
    
    # Testar frontend
    if curl -s -I http://$EC2_IP | grep "200 OK" > /dev/null; then
        print_success "✅ Frontend funcionando: http://$EC2_IP"
    else
        print_error "❌ Frontend não está respondendo"
    fi
}

# Função para parar aplicação
stop_app() {
    print_status "Parando aplicação..."
    
    if ! test_ssh; then
        return 1
    fi
    
    ssh -i $SSH_KEY $EC2_USER@$EC2_IP "cd /opt/devops-app && docker-compose down"
    
    print_success "✅ Aplicação parada!"
}

# Função para reiniciar aplicação
restart_app() {
    print_status "Reiniciando aplicação..."
    
    if ! test_ssh; then
        return 1
    fi
    
    ssh -i $SSH_KEY $EC2_USER@$EC2_IP "cd /opt/devops-app && docker-compose restart"
    
    print_success "✅ Aplicação reiniciada!"
}

# Função para backup
backup_app() {
    print_status "Fazendo backup da aplicação..."
    
    if ! test_ssh; then
        return 1
    fi
    
    # Criar backup
    ssh -i $SSH_KEY $EC2_USER@$EC2_IP "cd /opt/devops-app && tar -czf backup-$(date +%Y%m%d-%H%M%S).tar.gz docker-compose.yml"
    
    print_success "✅ Backup criado!"
}

# Main script
case "$1" in
    "setup")
        setup_server
        ;;
    "build")
        build_images
        ;;
    "deploy")
        deploy_app
        ;;
    "update")
        update_app
        ;;
    "logs")
        show_logs
        ;;
    "status")
        check_status
        ;;
    "stop")
        stop_app
        ;;
    "restart")
        restart_app
        ;;
    "backup")
        backup_app
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
