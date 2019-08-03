import React from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import Col from 'react-bootstrap/Col';

function NewTask(props) {
  const { submitCallback, changeCallback, textValue } = props;

  return(
    <ListGroup.Item>
      <Form onSubmit={submitCallback}>
        <Form.Row>
          <Form.Group as={Col} lg="8">
            <Form.Control as="input" placeholder="New Task" value={textValue} onChange={changeCallback}/>
          </Form.Group>
          <Form.Group as={Col} lg="4">
            <Button type="submit" className="float-right" variant="primary">
              New
            </Button>
          </Form.Group>
        </Form.Row>
      </Form>
    </ListGroup.Item>
  );
}

export default NewTask;
