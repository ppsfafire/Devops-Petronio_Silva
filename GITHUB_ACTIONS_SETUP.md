# 🔄 Configuração GitHub Actions

Este guia explica como configurar o GitHub Actions para automatizar o deploy da aplicação no seu servidor EC2.

## 📋 Visão Geral

O GitHub Actions está configurado para:
1. **Testar** o código em pull requests
2. **Build** das imagens Docker
3. **Push** para Docker Hub
4. **Deploy** automático no EC2

## 🔧 Configuração dos Secrets

### 1. Acessar Configurações do Repositório

1. Vá para seu repositório no GitHub
2. Clique em **Settings** (Configurações)
3. No menu lateral, clique em **Secrets and variables** → **Actions**

### 2. Adicionar Secrets Necessários

Clique em **New repository secret** e adicione os seguintes secrets:

#### 🔑 **DOCKER_USERNAME**
- **Name**: `DOCKER_USERNAME`
- **Value**: `ppsfafire`
- **Descrição**: Seu usuário do Docker Hub

#### 🔑 **DOCKER_PASSWORD**
- **Name**: `DOCKER_PASSWORD`
- **Value**: `[sua senha do Docker Hub]`
- **Descrição**: Sua senha do Docker Hub

#### 🔑 **EC2_SSH_KEY**
- **Name**: `EC2_SSH_KEY`
- **Value**: `[conteúdo completo da sua chave .pem]`
- **Descrição**: Chave SSH privada para acessar o EC2

**Para obter o conteúdo da chave SSH:**
```bash
# No seu computador local
cat ~/.ssh/sua-chave.pem
# Copie todo o conteúdo (incluindo as linhas BEGIN e END)
```

## 🔄 Fluxo do Pipeline

### 1. **Test Job**
- Executa quando há push ou pull request
- Instala dependências
- Executa testes (se existirem)

### 2. **Build and Push Job**
- Executa apenas em push (não em pull requests)
- Build das imagens Docker
- Push para Docker Hub com tags:
  - `ppsfafire/devops-backend:latest`
  - `ppsfafire/devops-frontend:latest`
  - `ppsfafire/devops-backend:[commit-sha]`
  - `ppsfafire/devops-frontend:[commit-sha]`

### 3. **Deploy Jobs**
- **Dev**: Deploy automático na branch `dev`
- **Staging**: Deploy automático na branch `staging`
- **Production**: Deploy automático na branch `master`

## 🚀 Como Funciona o Deploy

### Deploy Automático
```yaml
# Quando você faz push para dev/staging/master
git push origin dev    # → Deploy automático
git push origin staging # → Deploy automático
git push origin master  # → Deploy automático
```

### Processo de Deploy
1. **SSH** no servidor EC2
2. **Pull** das novas imagens do Docker Hub
3. **Restart** dos containers
4. **Health check** da aplicação

## 🔍 Verificar Status

### 1. **GitHub Actions**
- Vá para a aba **Actions** no seu repositório
- Veja o status dos workflows em tempo real

### 2. **Logs do Deploy**
- Clique em qualquer job para ver logs detalhados
- Útil para troubleshooting

### 3. **Verificar Aplicação**
Após o deploy, verifique:
- **Frontend**: http://18.117.195.190
- **Backend**: http://18.117.195.190:3001
- **Health**: http://18.117.195.190:3001/api/health

## 🛠️ Comandos Manuais

### Deploy Manual via GitHub Actions
1. Vá para **Actions** no GitHub
2. Clique em **CI/CD Pipeline**
3. Clique em **Run workflow**
4. Selecione a branch e clique em **Run workflow**

### Deploy Manual via Script Local
```bash
# Deploy manual
./deploy-ec2.sh deploy

# Verificar status
./deploy-ec2.sh status
```

## 🔧 Troubleshooting

### Problema: Erro de Autenticação Docker Hub
```bash
# Verificar se os secrets estão corretos
# DOCKER_USERNAME: ppsfafire
# DOCKER_PASSWORD: [sua senha]
```

### Problema: Erro de SSH
```bash
# Verificar se EC2_SSH_KEY está correto
# Deve conter toda a chave privada .pem
```

### Problema: Deploy Falha
```bash
# Verificar se o servidor está acessível
ssh -i ~/.ssh/sua-chave.pem ubuntu@18.117.195.190

# Verificar se Docker está rodando
docker ps
```

### Problema: Health Check Falha
```bash
# Verificar logs dos containers
./deploy-ec2.sh logs

# Verificar se as portas estão liberadas
sudo ufw status
```

## 📊 Monitoramento

### GitHub Actions Dashboard
- **Actions** → **CI/CD Pipeline** → Ver histórico de deploys
- **Settings** → **Secrets** → Gerenciar secrets

### Servidor EC2
```bash
# Verificar status da aplicação
./deploy-ec2.sh status

# Ver logs em tempo real
./deploy-ec2.sh logs
```

## 🔒 Segurança

### Secrets do GitHub
- ✅ Nunca commite secrets no código
- ✅ Use sempre GitHub Secrets
- ✅ Rotacione senhas regularmente

### Acesso SSH
- ✅ Use chaves SSH (não senhas)
- ✅ Mantenha a chave privada segura
- ✅ Use Security Groups na AWS

## 📈 Melhorias Futuras

### Possíveis Melhorias
1. **Notificações**: Slack, Discord, Email
2. **Rollback**: Deploy automático de versão anterior
3. **Blue/Green**: Deploy sem downtime
4. **Monitoring**: Integração com CloudWatch
5. **Backup**: Backup automático antes do deploy

## 🎯 Próximos Passos

1. **Configurar Secrets** no GitHub
2. **Fazer push** para testar o pipeline
3. **Monitorar** o primeiro deploy
4. **Configurar notificações** (opcional)

---

**🔄 GitHub Actions configurado para deploy automático no EC2!**
