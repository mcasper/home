import React, { useState } from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Col from 'react-bootstrap/Col';

import { Mutation } from 'react-apollo';
import { GET_INCOMPLETE_TASKS, CREATE_TASK } from '../queries.js';

const NewTask = (props) => {
  const [inputText, setInputText] = useState("");

  return(
    <Mutation
      mutation={CREATE_TASK}
      update={(cache, { data: { createTask: newTask } }) => {
        const { tasks } = cache.readQuery({ query: GET_INCOMPLETE_TASKS });
        cache.writeQuery({
          query: GET_INCOMPLETE_TASKS,
          data: { tasks: tasks.concat([newTask]) },
        });
      }}
    >
      {(create, { data }) => (
        <ListGroup.Item>
          <Form onSubmit={(e) => {
            e.preventDefault();
            create({
              variables: {
                input: {
                  text: inputText
                }
              }
            })
            setInputText("");
          }}>
            <Form.Row>
              <Form.Group as={Col} lg="8">
                <Form.Control as="input" value={inputText} placeholder="New Task" onChange={(e) => setInputText(e.target.value)} />
              </Form.Group>
              <Form.Group as={Col} lg="4">
                <Button type="submit" className="float-right" variant="primary">
                  New
                </Button>
              </Form.Group>
            </Form.Row>
          </Form>
        </ListGroup.Item>
      )}
    </Mutation>
  );
};

export default NewTask;
