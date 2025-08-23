const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Rota de teste
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Backend funcionando corretamente!',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Rota principal
app.get('/api', (req, res) => {
  res.json({
    message: 'Bem-vindo à API DevOps!',
    version: '1.0.0',
    author: 'Petronio Silva'
  });
});

// Rota para dados de exemplo
app.get('/api/data', (req, res) => {
  res.json({
    items: [
      { id: 1, name: 'Item 1', description: 'Descrição do item 1' },
      { id: 2, name: 'Item 2', description: 'Descrição do item 2' },
      { id: 3, name: 'Item 3', description: 'Descrição do item 3' }
    ],
    total: 3
  });
});

// Rota para criar item
app.post('/api/data', (req, res) => {
  const { name, description } = req.body;
  
  if (!name || !description) {
    return res.status(400).json({ error: 'Nome e descrição são obrigatórios' });
  }
  
  const newItem = {
    id: Date.now(),
    name,
    description,
    createdAt: new Date().toISOString()
  };
  
  res.status(201).json(newItem);
});

// Middleware para rotas não encontradas
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Rota não encontrada' });
});

// Middleware de tratamento de erros
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Erro interno do servidor' });
});

app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando na porta ${PORT}`);
  console.log(`📡 Ambiente: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🔗 URL: http://localhost:${PORT}`);
});
