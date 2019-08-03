import React from 'react';
import TaskRow from './TaskRow.jsx';
import ListGroup from 'react-bootstrap/ListGroup';
import Container from 'react-bootstrap/Container';
import NewTask from './NewTask.jsx';

import { Query } from 'react-apollo';
import { GET_INCOMPLETE_TASKS } from '../queries.js';

const TaskList = () => {
  return(
    <Query query={GET_INCOMPLETE_TASKS}>
      {({ loading, error, data }) => {
        if (loading) return 'Loading...';
        if (error) return `Error! ${error.message}`;

        return(
          <Container>
            <h1 style={{textAlign: 'center', margin: '35px'}}>Tasks</h1>

            <ListGroup>
              {data.tasks.map(task => <TaskRow task={task} key={task.id} />)}
              <NewTask key="form"/>
            </ListGroup>
          </Container>
        );
      }}
    </Query>
  );
};

export default TaskList
