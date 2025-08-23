# 🚀 Configuração EC2 - Aplicação DevOps

Este guia explica como configurar e fazer deploy da aplicação no seu servidor EC2 existente.

## 📋 Informações do Servidor

- **DNS**: `ec2-18-117-195-190.us-east-2.compute.amazonaws.com`
- **IP**: `18.117.195.190`
- **Região**: `us-east-2` (Ohio)
- **Sistema**: Ubuntu (assumido)

## 🔧 Pré-requisitos

### 1. Chave SSH
Você precisa da chave `.pem` para acessar o servidor. Ajuste o caminho no script:

```bash
# Editar o arquivo deploy-ec2.sh
SSH_KEY="~/.ssh/sua-chave.pem"  # Ajuste para o caminho correto
```

### 2. Security Group
Verificar se as seguintes portas estão liberadas:
- **22** - SSH
- **80** - HTTP (Frontend)
- **3001** - API (Backend)

### 3. Acesso SSH
Testar conectividade:
```bash
ssh -i ~/.ssh/sua-chave.pem ubuntu@18.117.195.190
```

## 🚀 Deploy Rápido

### 1. Configurar Servidor
```bash
# Primeira vez - configurar servidor
./deploy-ec2.sh setup
```

### 2. Build e Push das Imagens
```bash
# Build local e push para Docker Hub
./deploy-ec2.sh build
```

### 3. Deploy da Aplicação
```bash
# Deploy no servidor EC2
./deploy-ec2.sh deploy
```

### 4. Verificar Status
```bash
# Verificar se está funcionando
./deploy-ec2.sh status
```

## 🌐 URLs da Aplicação

Após o deploy, a aplicação estará disponível em:

- **🌐 Frontend**: http://18.117.195.190
- **🔧 Backend**: http://18.117.195.190:3001
- **📊 Health Check**: http://18.117.195.190:3001/api/health

## 🛠️ Comandos do Script

| Comando | Descrição |
|---------|-----------|
| `setup` | Configurar servidor EC2 (Docker, etc.) |
| `build` | Build e push das imagens para Docker Hub |
| `deploy` | Deploy da aplicação no servidor |
| `update` | Atualizar aplicação (pull novas imagens) |
| `status` | Verificar status da aplicação |
| `logs` | Ver logs dos containers |
| `restart` | Reiniciar aplicação |
| `stop` | Parar aplicação |
| `backup` | Fazer backup dos dados |
| `help` | Mostrar ajuda |

## 🔍 Troubleshooting

### Problema: Erro de SSH
```bash
# Verificar chave SSH
ls -la ~/.ssh/sua-chave.pem

# Verificar permissões
chmod 400 ~/.ssh/sua-chave.pem

# Testar conectividade
ssh -i ~/.ssh/sua-chave.pem ubuntu@18.117.195.190
```

### Problema: Porta não acessível
```bash
# Verificar Security Group na AWS
# Liberar portas 22, 80, 3001

# Verificar firewall no servidor
ssh -i ~/.ssh/sua-chave.pem ubuntu@18.117.195.190 "sudo ufw status"
```

### Problema: Docker não instalado
```bash
# Executar setup novamente
./deploy-ec2.sh setup
```

### Problema: Imagens não encontradas
```bash
# Fazer login no Docker Hub
docker login

# Push das imagens
./deploy-ec2.sh build
```

## 📊 Monitoramento

### Verificar Logs
```bash
# Logs em tempo real
./deploy-ec2.sh logs

# Logs específicos
ssh -i ~/.ssh/sua-chave.pem ubuntu@18.117.195.190 "cd /opt/devops-app && docker-compose logs backend"
```

### Verificar Recursos
```bash
# Status dos containers
ssh -i ~/.ssh/sua-chave.pem ubuntu@18.117.195.190 "cd /opt/devops-app && docker-compose ps"

# Uso de recursos
ssh -i ~/.ssh/sua-chave.pem ubuntu@18.117.195.190 "docker stats"
```

## 🔄 Atualizações

### Atualizar Aplicação
```bash
# Atualizar código local
git pull origin dev

# Build e push das novas imagens
./deploy-ec2.sh build

# Deploy da atualização
./deploy-ec2.sh update
```

### Rollback
```bash
# Parar aplicação
./deploy-ec2.sh stop

# Deploy versão anterior
./deploy-ec2.sh deploy
```

## 🔒 Segurança

### Configurações Recomendadas

1. **HTTPS**: Configurar certificado SSL
2. **Firewall**: UFW configurado no servidor
3. **Logs**: Monitoramento de logs
4. **Backup**: Backups regulares

### Configurar HTTPS (Opcional)
```bash
# Instalar Certbot
ssh -i ~/.ssh/sua-chave.pem ubuntu@18.117.195.190 "sudo apt-get install certbot python3-certbot-nginx -y"

# Obter certificado (se tiver domínio)
sudo certbot --nginx -d seu-dominio.com
```

## 💰 Custos

**Custos estimados do EC2 (us-east-2):**
- **t3.micro**: ~$8-12/mês
- **t3.small**: ~$15-20/mês
- **Transferência de dados**: ~$5-10/mês

## 📞 Suporte

Para problemas específicos do EC2:

1. **Verificar conectividade**: `./deploy-ec2.sh status`
2. **Verificar logs**: `./deploy-ec2.sh logs`
3. **Reiniciar aplicação**: `./deploy-ec2.sh restart`
4. **Configurar servidor**: `./deploy-ec2.sh setup`

---

**🚀 Servidor EC2 configurado e pronto para deploy!**
