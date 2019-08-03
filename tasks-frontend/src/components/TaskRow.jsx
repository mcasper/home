import React from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Button from 'react-bootstrap/Button';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';

function TaskRow(props) {
  const { task, clickCallback } = props;

  return(
    <ListGroup.Item>
      <Row>
        <Col lg={4}>{task.text}</Col>
        <Col lg={{ span: 4, offset: 4 }}>
          <Button className="float-right" variant="primary" onClick={() => clickCallback(task.id)}>
            Complete
          </Button>
        </Col>
      </Row>
    </ListGroup.Item>
  )
}

export default TaskRow
