import React from 'react';
import './App.css';
import Navbar from './components/Navbar.jsx';
import UncategorizedTransactions from './components/UncategorizedTransactions.jsx';

function App() {
  return (
    <React.Fragment>
      <Navbar />
      <UncategorizedTransactions />
    </React.Fragment>
  );
}

export default App;
