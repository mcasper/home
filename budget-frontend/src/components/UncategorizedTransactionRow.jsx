import React, { useState } from 'react';
import ListGroup from 'react-bootstrap/ListGroup';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import Container from 'react-bootstrap/Container';
import { CATEGORIZE_TRANSACTION } from '../queries.js';
import { GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS } from '../queries.js';
import { useMutation } from '@apollo/react-hooks';
import { formattedAmount } from '../utilities.js';

function UncategorizedTransactionRow(props) {
  let { transaction, categories } = props;
  let [selectedValue, setSelectedValue] = useState("Select a category");
  const [categorizeTransaction, { _data }] = useMutation(
    CATEGORIZE_TRANSACTION,
    {
      update(cache, { data: { createCategorizedTransaction: categorizedTransaction } }) {
        const { categories, transactions } = cache.readQuery({ query: GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS });
        const filteredTransactions = transactions.filter(innerTx => innerTx.transactionId !== categorizedTransaction.originId)
        cache.writeQuery({
          query: GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS,
          data: { transactions: filteredTransactions, categories: categories },
        });
      }
    }
  );

  return (
    <ListGroup.Item>
      <p>{transaction.name}</p>
      <p>${formattedAmount(transaction.amount)}</p>
      <p>{transaction.date}</p>
      <Container>
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
            <Container>
              {categories.map(category => <Button variant="primary" onClick={() => setSelectedValue(category.id)} className="mt-2 mr-4" key={category.id} type="submit">{category.name}</Button>)}
            </Container>
          </Form.Row>
        </Form>
      </Container>
    </ListGroup.Item >
  )
}

export default UncategorizedTransactionRow;
