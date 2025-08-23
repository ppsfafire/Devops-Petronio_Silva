import { render, screen, waitFor } from '@testing-library/react';
import App from './App';

// Mock axios para evitar problemas de rede nos testes
jest.mock('axios', () => ({
  get: jest.fn(() => Promise.resolve({ data: {} })),
  post: jest.fn(() => Promise.resolve({ data: {} }))
}));

// Suprimir warnings do console para os testes
const originalError = console.error;
beforeAll(() => {
  console.error = (...args) => {
    if (
      typeof args[0] === 'string' &&
      args[0].includes('Warning: An update to App inside a test was not wrapped in act')
    ) {
      return;
    }
    originalError.call(console, ...args);
  };
});

afterAll(() => {
  console.error = originalError;
});

test('renders application title', async () => {
  render(<App />);
  const titleElement = screen.getByText(/Aplicação DevOps/i);
  expect(titleElement).toBeInTheDocument();
});

test('renders Petronio Silva name in title', async () => {
  render(<App />);
  const titleElement = screen.getByText(/🚀 Aplicação DevOps - Petronio Silva/i);
  expect(titleElement).toBeInTheDocument();
});

test('renders status section', async () => {
  render(<App />);
  const statusElement = screen.getByText(/Status da API/i);
  expect(statusElement).toBeInTheDocument();
});
