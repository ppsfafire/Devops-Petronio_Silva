# 🔑 Guia de Configuração SSH para GitHub Actions

## 🎯 **Configuração da Chave SSH**

### 1. Converter PPK para OpenSSH
Se você tem uma chave PPK, converta para formato OpenSSH usando:
- **PuTTYgen** (Windows): Load > Conversions > Export OpenSSH key
- **ssh-keygen** (Linux/Mac): `ssh-keygen -p -f sua-chave.ppk -m pem`

### 2. Formato da Chave
A chave deve estar no formato:
```
-----BEGIN RSA PRIVATE KEY-----
... (conteúdo da chave) ...
-----END RSA PRIVATE KEY-----
```

### 3. Configurar no GitHub Actions
1. Acesse: https://github.com/ppsfafire/Devops-Petronio_Silva/settings/secrets/actions
2. Edite o secret: `EC2_SSH_KEY`
3. Cole a chave privada completa (incluindo BEGIN e END)

### 4. Testar Localmente
```bash
# Salvar chave em arquivo temporário
cat > temp_key.pem << 'EOF'
# Cole aqui sua chave privada
EOF

# Dar permissão correta
chmod 600 temp_key.pem

# Testar conexão
ssh -i temp_key.pem -o StrictHostKeyChecking=no ubuntu@18.117.195.190 "echo 'Conexão SSH funcionando!'"

# Limpar arquivo
rm temp_key.pem
```

## 🎯 **Próximos Passos**
1. Configure o secret `EC2_SSH_KEY` no GitHub
2. Execute o pipeline
3. Verifique o deploy automático

## 📋 **Checklist**
- [ ] Chave convertida para formato OpenSSH
- [ ] Secret configurado no GitHub Actions
- [ ] Teste local bem-sucedido
- [ ] Pipeline executado
