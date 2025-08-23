#!/bin/bash

# Script para testar conexão SSH com EC2
echo "🔍 Testando conexão SSH com EC2..."

# Configurações
EC2_HOST="ec2-18-117-195-190.us-east-2.compute.amazonaws.com"
EC2_IP="18.117.195.190"
EC2_USER="ubuntu"

echo "📍 Host: $EC2_HOST"
echo "📍 IP: $EC2_IP"
echo "👤 User: $EC2_USER"

# Testar conexão SSH
echo "🔑 Testando conexão SSH..."
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -i ~/.ssh/id_ed25519 $EC2_USER@$EC2_IP "echo '✅ Conexão SSH bem-sucedida!'"

if [ $? -eq 0 ]; then
    echo "✅ Conexão SSH funcionando!"
else
    echo "❌ Falha na conexão SSH"
    echo "💡 Verifique:"
    echo "   - Se a chave SSH está configurada corretamente"
    echo "   - Se o EC2 está rodando"
    echo "   - Se o Security Group permite SSH (porta 22)"
    echo "   - Se o usuário é 'ubuntu'"
fi
