const request = require('supertest');
const express = require('express');

// Mock do servidor para testes
const app = express();
app.use(express.json());

// Rotas básicas para teste
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Backend funcionando corretamente!',
    timestamp: new Date().toISOString(),
    environment: 'test'
  });
});

app.get('/api', (req, res) => {
  res.json({
    message: 'Bem-vindo à API DevOps!',
    version: '1.0.0',
    author: 'Petronio Silva'
  });
});

describe('Backend API Tests', () => {
  test('GET /api/health should return status OK', async () => {
    const response = await request(app).get('/api/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('OK');
    expect(response.body.message).toBe('Backend funcionando corretamente!');
  });

  test('GET /api should return welcome message', async () => {
    const response = await request(app).get('/api');
    expect(response.status).toBe(200);
    expect(response.body.message).toBe('Bem-vindo à API DevOps!');
    expect(response.body.author).toBe('Petronio Silva');
  });
});

module.exports = app;
