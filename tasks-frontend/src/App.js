import React from 'react';
import Navbar from './components/Navbar.jsx'
import TaskList from './components/TaskList.jsx'

function App() {
  return (
    <React.Fragment>
      <Navbar />
      <TaskList />
    </React.Fragment>
  );
}

export default App;
