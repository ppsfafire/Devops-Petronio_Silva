# 🔑 Configuração SSH para GitHub Actions

## ❌ Problema Atual
O GitHub Actions está falhando na autenticação SSH com o EC2:
```
ssh: handshake failed: ssh: unable to authenticate, attempted methods [none publickey], no supported methods remain
```

## 🔧 Solução

### 1. Obter a Chave Privada Correta
A chave privada que você forneceu anteriormente deve ser configurada no GitHub Actions.

**⚠️ IMPORTANTE:** A chave privada foi fornecida anteriormente e deve ser usada exatamente como foi compartilhada, incluindo as linhas `-----BEGIN RSA PRIVATE KEY-----` e `-----END RSA PRIVATE KEY-----`.

### 2. Configurar no GitHub Actions

1. **Acesse o repositório no GitHub**
2. **Vá para Settings > Secrets and variables > Actions**
3. **Edite o secret `EC2_SSH_KEY`**
4. **Cole a chave privada completa (incluindo as linhas BEGIN e END)**

### 3. Verificar Configurações do EC2

Certifique-se de que:
- ✅ EC2 está rodando
- ✅ Security Group permite SSH (porta 22)
- ✅ Usuário é `ubuntu`
- ✅ Chave pública está configurada no EC2

### 4. Testar Localmente

Para testar se a chave funciona:

```bash
# Salvar a chave em um arquivo temporário (use a chave que você forneceu)
cat > temp_key.pem << 'EOF'
# Cole aqui a chave privada completa que você forneceu anteriormente
# Incluindo as linhas BEGIN e END
EOF

# Dar permissão correta
chmod 600 temp_key.pem

# Testar conexão
ssh -i temp_key.pem -o StrictHostKeyChecking=no ubuntu@18.117.195.190 "echo 'Conexão SSH funcionando!'"

# Limpar arquivo temporário
rm temp_key.pem
```

## 🎯 Próximos Passos

1. **Configure o secret `EC2_SSH_KEY` no GitHub**
2. **Teste a conexão SSH localmente**
3. **Execute o pipeline novamente**

## 📋 Checklist

- [ ] Chave privada configurada no GitHub Actions
- [ ] EC2 está rodando
- [ ] Security Group permite SSH (porta 22)
- [ ] Usuário `ubuntu` configurado
- [ ] Chave pública no EC2
- [ ] Teste local bem-sucedido
