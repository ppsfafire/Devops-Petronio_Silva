import { render, screen } from '@testing-library/react';
import App from './App';

test('renders application title', () => {
  render(<App />);
  const titleElement = screen.getByText(/Aplicação DevOps/i);
  expect(titleElement).toBeInTheDocument();
});

test('renders Petronio Silva name', () => {
  render(<App />);
  const nameElement = screen.getByText(/Petronio Silva/i);
  expect(nameElement).toBeInTheDocument();
});

test('renders status section', () => {
  render(<App />);
  const statusElement = screen.getByText(/Status da API/i);
  expect(statusElement).toBeInTheDocument();
});
