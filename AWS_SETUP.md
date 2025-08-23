# 🔧 Guia de Configuração AWS

Este guia detalha como configurar toda a infraestrutura AWS necessária para o projeto DevOps.

## 📋 Pré-requisitos

- Conta AWS ativa
- AWS CLI instalado e configurado
- Terraform instalado
- Permissões adequadas na AWS

## 🚀 Passo a Passo

### 1. Configurar AWS CLI

```bash
# Instalar AWS CLI (se necessário)
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Configurar credenciais
aws configure
```

**Informações necessárias:**
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `us-east-1`
- Default output format: `json`

### 2. Criar Usuário IAM para GitHub Actions

#### 2.1 Criar Política IAM

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage",
                "ecs:UpdateService",
                "ecs:DescribeServices",
                "ecs:DescribeTaskDefinition",
                "ecs:RegisterTaskDefinition",
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": "*"
        }
    ]
}
```

#### 2.2 Criar Usuário e Anexar Política

```bash
# Criar política
aws iam create-policy \
    --policy-name DevOpsPetronioSilvaPolicy \
    --policy-document file://policy.json

# Criar usuário
aws iam create-user --user-name github-actions-devops

# Anexar política ao usuário
aws iam attach-user-policy \
    --user-name github-actions-devops \
    --policy-arn arn:aws:iam::YOUR_ACCOUNT_ID:policy/DevOpsPetronioSilvaPolicy

# Criar access keys
aws iam create-access-key --user-name github-actions-devops
```

### 3. Criar Bucket S3 para Terraform State

```bash
# Criar bucket
aws s3 mb s3://devops-petronio-silva-terraform-state

# Habilitar versionamento
aws s3api put-bucket-versioning \
    --bucket devops-petronio-silva-terraform-state \
    --versioning-configuration Status=Enabled

# Configurar encriptação
aws s3api put-bucket-encryption \
    --bucket devops-petronio-silva-terraform-state \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'
```

### 4. Deploy da Infraestrutura com Terraform

```bash
# Navegar para diretório de infraestrutura
cd infrastructure

# Inicializar Terraform
terraform init

# Verificar configuração
terraform validate

# Planejar deploy
terraform plan -var="environment=dev"

# Aplicar infraestrutura
terraform apply -var="environment=dev"
```

### 5. Configurar GitHub Secrets

No repositório GitHub, vá em **Settings > Secrets and variables > Actions** e adicione:

- `AWS_ACCESS_KEY_ID`: Access Key do usuário criado
- `AWS_SECRET_ACCESS_KEY`: Secret Key do usuário criado

### 6. Verificar Recursos Criados

#### 6.1 ECR Repositories

```bash
# Listar repositórios
aws ecr describe-repositories

# Verificar imagens
aws ecr describe-images --repository-name devops-petronio-silva-backend
aws ecr describe-images --repository-name devops-petronio-silva-frontend
```

#### 6.2 ECS Clusters

```bash
# Listar clusters
aws ecs list-clusters

# Verificar serviços
aws ecs list-services --cluster devops-cluster-dev
```

#### 6.3 Application Load Balancer

```bash
# Listar load balancers
aws elbv2 describe-load-balancers

# Verificar target groups
aws elbv2 describe-target-groups
```

## 🔍 Monitoramento e Logs

### CloudWatch Logs

```bash
# Verificar grupos de logs
aws logs describe-log-groups

# Verificar streams de logs
aws logs describe-log-streams --log-group-name /ecs/devops-backend
```

### Métricas ECS

```bash
# Verificar métricas do serviço
aws cloudwatch get-metric-statistics \
    --namespace AWS/ECS \
    --metric-name CPUUtilization \
    --dimensions Name=ServiceName,Value=devops-service-dev \
    --start-time 2024-01-01T00:00:00Z \
    --end-time 2024-01-02T00:00:00Z \
    --period 3600 \
    --statistics Average
```

## 🛠️ Comandos Úteis

### Verificar Status dos Serviços

```bash
# Status do ECS
aws ecs describe-services \
    --cluster devops-cluster-dev \
    --services devops-service-dev

# Status do ALB
aws elbv2 describe-target-health \
    --target-group-arn YOUR_TARGET_GROUP_ARN
```

### Atualizar Serviços Manualmente

```bash
# Forçar novo deploy
aws ecs update-service \
    --cluster devops-cluster-dev \
    --service devops-service-dev \
    --force-new-deployment
```

### Limpar Recursos

```bash
# Destruir infraestrutura
terraform destroy -var="environment=dev"

# Remover bucket S3
aws s3 rb s3://devops-petronio-silva-terraform-state --force
```

## 🔒 Segurança

### Security Groups

Os security groups são configurados automaticamente pelo Terraform:

- **ALB**: Permite tráfego HTTP (80) e HTTPS (443)
- **ECS**: Permite tráfego apenas do ALB na porta 3001

### IAM Roles

- **ECSTaskExecutionRole**: Para executar containers ECS
- **ECSTaskRole**: Para permissões da aplicação

## 📊 Custos Estimados

**Custos mensais aproximados (us-east-1):**

- ECS Fargate: ~$30-50
- ALB: ~$20
- ECR: ~$5-10
- CloudWatch Logs: ~$5-15
- **Total estimado: $60-95/mês**

## 🚨 Troubleshooting

### Problemas Comuns

1. **Erro de permissão IAM**
   ```bash
   # Verificar permissões
   aws sts get-caller-identity
   ```

2. **Container não inicia**
   ```bash
   # Verificar logs
   aws logs get-log-events \
       --log-group-name /ecs/devops-backend \
       --log-stream-name latest
   ```

3. **ALB não responde**
   ```bash
   # Verificar target health
   aws elbv2 describe-target-health \
       --target-group-arn YOUR_TARGET_GROUP_ARN
   ```

## 📞 Suporte

Para problemas específicos da AWS:

- **AWS Support**: Se você tem plano de suporte
- **AWS Forums**: https://forums.aws.amazon.com/
- **AWS Documentation**: https://docs.aws.amazon.com/

---

**⚠️ Importante**: Sempre use as melhores práticas de segurança e nunca commite credenciais no código!
