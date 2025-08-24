import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [healthStatus, setHealthStatus] = useState(null);
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);
  const [newItem, setNewItem] = useState({ name: '', description: '' });
  const [message, setMessage] = useState('');

  const API_BASE_URL = process.env.REACT_APP_API_URL;

  // Verificar status da API
  const checkHealth = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_BASE_URL}/api/health`);
      setHealthStatus(response.data);
      setMessage('✅ API conectada com sucesso!');
    } catch (error) {
      setHealthStatus({ status: 'ERROR', message: 'Erro ao conectar com a API' });
      setMessage('❌ Erro ao conectar com a API');
    } finally {
      setLoading(false);
    }
  };

  // Carregar dados
  const loadData = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_BASE_URL}/api/data`);
      setData(response.data.items);
      setMessage('📊 Dados carregados com sucesso!');
    } catch (error) {
      setMessage('❌ Erro ao carregar dados');
    } finally {
      setLoading(false);
    }
  };

  // Adicionar novo item
  const addItem = async (e) => {
    e.preventDefault();
    if (!newItem.name || !newItem.description) {
      setMessage('⚠️ Preencha todos os campos');
      return;
    }

    try {
      setLoading(true);
      const response = await axios.post(`${API_BASE_URL}/api/data`, newItem);
      setData([...data, response.data]);
      setNewItem({ name: '', description: '' });
      setMessage('✅ Item adicionado com sucesso!');
    } catch (error) {
      setMessage('❌ Erro ao adicionar item');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    checkHealth();
    loadData();
  }, []);

  return (
    <div className="App">
      <div className="container">
        <header className="card">
          <h1>🚀 Aplicação DevOps - Petronio Silva</h1>
          <p>Demonstração de CI/CD com GitHub Actions e AWS</p>
          <div className="version-info">
            <span>Versão: 1.0.0</span>
            <span>Ambiente: {process.env.NODE_ENV || 'development'}</span>
          </div>
        </header>

        {message && (
          <div className={`message ${message.includes('❌') ? 'error' : 'success'}`}>
            {message}
          </div>
        )}

        <div className="grid">
          <div className="card">
            <h2>🔍 Status da API</h2>
            {healthStatus ? (
              <div className="status-info">
                <p><strong>Status:</strong> {healthStatus.status}</p>
                <p><strong>Mensagem:</strong> {healthStatus.message}</p>
                {healthStatus.timestamp && (
                  <p><strong>Timestamp:</strong> {new Date(healthStatus.timestamp).toLocaleString('pt-BR')}</p>
                )}
                {healthStatus.environment && (
                  <p><strong>Ambiente:</strong> {healthStatus.environment}</p>
                )}
              </div>
            ) : (
              <p>Carregando status...</p>
            )}
            <button className="btn" onClick={checkHealth} disabled={loading}>
              {loading ? 'Verificando...' : 'Verificar Status'}
            </button>
          </div>

          <div className="card">
            <h2>📝 Adicionar Novo Item</h2>
            <form onSubmit={addItem}>
              <div className="form-group">
                <label htmlFor="name">Nome:</label>
                <input
                  type="text"
                  id="name"
                  value={newItem.name}
                  onChange={(e) => setNewItem({...newItem, name: e.target.value})}
                  placeholder="Digite o nome do item"
                />
              </div>
              <div className="form-group">
                <label htmlFor="description">Descrição:</label>
                <textarea
                  id="description"
                  value={newItem.description}
                  onChange={(e) => setNewItem({...newItem, description: e.target.value})}
                  placeholder="Digite a descrição do item"
                  rows="3"
                />
              </div>
              <button type="submit" className="btn btn-success" disabled={loading}>
                {loading ? 'Adicionando...' : 'Adicionar Item'}
              </button>
            </form>
          </div>
        </div>

        <div className="card">
          <div className="card-header">
            <h2>📊 Lista de Itens</h2>
            <button className="btn" onClick={loadData} disabled={loading}>
              {loading ? 'Carregando...' : 'Atualizar'}
            </button>
          </div>
          {data.length > 0 ? (
            <div className="items-list">
              {data.map((item) => (
                <div key={item.id} className="item">
                  <h3>{item.name}</h3>
                  <p>{item.description}</p>
                  {item.createdAt && (
                    <small>Criado em: {new Date(item.createdAt).toLocaleString('pt-BR')}</small>
                  )}
                </div>
              ))}
            </div>
          ) : (
            <p>Nenhum item encontrado.</p>
          )}
        </div>

        <footer className="card">
          <p>© 2024 Petronio Silva - Projeto DevOps</p>
          <p>GitHub: <a href="https://github.com/ppsfafire/Devops-Petronio_Silva.git" target="_blank" rel="noopener noreferrer">ppsfafire/Devops-Petronio_Silva</a></p>
        </footer>
      </div>
    </div>
  );
}

export default App;
