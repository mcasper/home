import React, { useState } from "react";
import Form from "react-bootstrap/Form";
import Col from "react-bootstrap/Col";
import Button from "react-bootstrap/Button";
import Container from "react-bootstrap/Container";
import { CREATE_CATEGORY } from '../queries.js';
import { useMutation } from '@apollo/react-hooks';
import { useHistory } from "react-router"

function NewCategory(props) {
  let history = useHistory();
  let [name, setName] = useState("");
  let [createCategory, { _data }] = useMutation(CREATE_CATEGORY);

  return (
    <Container className="mt-8">
      <Form onSubmit={(e) => {
        e.preventDefault();
        createCategory({ variables: { name } });
        history.push("/budget");
      }}>
        <Form.Row>
          <Form.Group as={Col} lg="8">
            <Form.Control as="input" value={name} placeholder="New Category" onChange={(e) => setName(e.target.value)} />
          </Form.Group>
          <Form.Group as={Col} lg="4">
            <Button type="submit" className="float-right" variant="primary">
              Submit
          </Button>
          </Form.Group>
        </Form.Row>
      </Form>
    </Container>
  )
}

export default NewCategory;
