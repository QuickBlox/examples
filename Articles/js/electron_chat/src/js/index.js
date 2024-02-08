import React from 'react';
import { createRoot } from 'react-dom/client';
import App from "./App";
const container = document.getElementById('electronChat');
const root = createRoot(container); // createRoot(container!) if you use TypeScript
root.render(<App />);
