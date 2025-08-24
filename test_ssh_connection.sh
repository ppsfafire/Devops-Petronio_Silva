#!/bin/bash

echo "🔍 Testando conexão SSH com EC2..."

# Configurações
EC2_IP="18.117.195.190"
EC2_USER="ubuntu"

echo "📍 IP: $EC2_IP"
echo "👤 User: $EC2_USER"

# Testar com diferentes usuários
for USER in ubuntu ec2-user admin root; do
    echo "🔑 Testando usuário: $USER"
    ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -i ~/.ssh/id_ed25519 $USER@$EC2_IP "echo '✅ Conexão SSH bem-sucedida com $USER!'" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Usuário correto encontrado: $USER"
        break
    else
        echo "❌ Falha com usuário: $USER"
    fi
done

echo ""
echo "💡 Se todos falharam, verifique:"
echo "   - Se a chave pública está no EC2"
echo "   - Se o Security Group permite SSH (porta 22)"
echo "   - Se o EC2 está rodando"
echo "   - Se o usuário é correto"
