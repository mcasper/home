import React, { useState } from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import { CATEGORIZE_TRANSACTION } from '../queries.js'
import { GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS } from '../queries.js';
import { useMutation } from '@apollo/react-hooks';

function UncategorizedTransactionRow(props) {
  let { transaction, categories } = props;
  let [selectedValue, setSelectedValue] = useState("Select a category");
  const [categorizeTransaction, { data }] = useMutation(
    CATEGORIZE_TRANSACTION,
    {
      update(cache, { data: { createCategorizedTransaction: categorizedTransaction } }) {
        const { transactions } = cache.readQuery({ query: GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS });
        const filteredTransactions = transactions.filter(innerTx => innerTx.transactionId !== categorizedTransaction.originId)
        cache.writeQuery({
          query: GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS,
          data: { transactions: filteredTransactions },
        });
      }
    }
  );

  return (
    <ListGroup.Item>
      <p>{transaction.name}</p>
      <p>{transaction.amount}</p>
      <p>{transaction.date}</p>
      <Form onSubmit={(e) => {
        e.preventDefault();
        categorizeTransaction({
          variables: {
            categoryId: selectedValue,
            originId: transaction.transactionId,
          }
        })
      }}>
        <Form.Row>
          <Form.Group>
            <Form.Control as="select" className="custom-select custom-select-lg mb-3" value={selectedValue} onChange={(e) => setSelectedValue(e.target.value)}>
              <option key="default">Select a category</option>
              {categories.map(category => <option key={category.id} value={category.id}>{category.name}</option>)}
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
