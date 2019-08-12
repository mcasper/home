import React, { useState } from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';

function UncategorizedTransactionRow(props) {
  let { transaction } = props;
  let [selectedValue, setSelectedValue] = useState("Select a category");

  let categories = ["Entertainment", "Groceries", "Clothes"]
  return(
    <ListGroup.Item>
      <p>{transaction.name}</p>
      <p>{transaction.amount}</p>
      <p>{transaction.date}</p>
      <Form onSubmit={(e) => {
        e.preventDefault();
        /*create({
          variables: {
            input: {
              text: inputText
            }
          }
        })*/
      }}>
        <Form.Row>
          <Form.Group>
            <Form.Control as="select" className="custom-select custom-select-lg mb-3" value={selectedValue} onChange={(e) => setSelectedValue(e.target.value)}>
              <option key="default">Select a category</option>
              {categories.map(category => <option key={category}>{category}</option>)}
            </Form.Control>
          </Form.Group>

          <Form.Group>
            <Button type="submit" variant="primary">
              New
            </Button>
          </Form.Group>
        </Form.Row>
      </Form>
    </ListGroup.Item>
  )
}

export default UncategorizedTransactionRow;
