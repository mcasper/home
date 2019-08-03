import React from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Button from 'react-bootstrap/Button';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';

import { Mutation } from 'react-apollo';
import { GET_INCOMPLETE_TASKS, UPDATE_TASK } from '../queries.js';

function TaskRow(props) {
  const { task } = props;

  return(
    <Mutation
      mutation={UPDATE_TASK}
      update={(cache, { data: { updateTask: updatedTask } }) => {
        const { tasks } = cache.readQuery({ query: GET_INCOMPLETE_TASKS });
        const filteredTasks = tasks.filter(innerTask => innerTask.id !== updatedTask.id)
        cache.writeQuery({
          query: GET_INCOMPLETE_TASKS,
          data: { tasks: filteredTasks },
        });
      }}
    >
      {updateTask => (
        <ListGroup.Item>
          <Row>
            <Col lg={4}>{task.text}</Col>
            <Col lg={{ span: 4, offset: 4 }}>
              <Button disabled={task.complete} className="float-right" variant="primary" onClick={() => {
                updateTask({ variables: { id: task.id, input: { complete: true } } });
              }}>
              Complete
            </Button>
          </Col>
        </Row>
      </ListGroup.Item>
      )}
    </Mutation>
  )
}

export default TaskRow
