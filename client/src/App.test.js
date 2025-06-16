import { render, screen } from '@testing-library/react';
import { BrowserRouter } from 'react-router-dom';
import App from './App';

// Mock the services to avoid network calls during testing
jest.mock('./services/memberService', () => ({
  getMemberByNumber: jest.fn()
}));

test('renders app without crashing', () => {
  render(
    <BrowserRouter>
      <App />
    </BrowserRouter>
  );

  // App should render login page by default when not authenticated
  expect(screen.getByRole('main')).toBeInTheDocument();
});
