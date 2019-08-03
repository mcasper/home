import React, { useState } from 'react';
import TaskRow from './TaskRow.jsx';
import ListGroup from 'react-bootstrap/ListGroup';
import Container from 'react-bootstrap/Container';

function TaskList() {
  const initialTasks = [
    {
      id: 1,
      text: 'Feed the dog',
      complete: false
    },
    {
      id: 2,
      text: 'Clean the room',
      complete: false
    },
    {
      id: 3,
      text: 'Make dinner',
      complete: false
    }
  ]
  const [tasks, setTasks] = useState(initialTasks);

  const handleClick = (taskId) => {
    var newTasks = [];
    tasks.forEach(function(task) {
      if (task.id === taskId) {
        task.complete = true;
        task.text = (task.text + ' - I was clicked');
      }
      newTasks.push(task);
    });
    setTasks(newTasks);
  }

  return(
    <Container>
      <h1 style={{textAlign: 'center', margin: '35px'}}>Tasks</h1>

      <ListGroup>
        {tasks.map(task => <TaskRow task={task} clickCallback={handleClick} key={task.id} />)}
      </ListGroup>
    </Container>
  )
}

export default TaskList
