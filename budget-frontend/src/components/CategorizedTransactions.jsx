import React from 'react';
import Container from 'react-bootstrap/Container';
import Col from 'react-bootstrap/Col';
import ListGroup from 'react-bootstrap/ListGroup';
import NewItem from './NewItem.jsx';

import { formattedAmount } from '../utilities.js';
import { useQuery } from '@apollo/react-hooks';
import { GET_CATEGORIZED_TRANSACTIONS } from '../queries.js';

function CategorizedTransactions(props) {
  let { category, totalSpend } = props;
  const { loading, error, data } = useQuery(
    GET_CATEGORIZED_TRANSACTIONS,
    {
      variables: { categoryId: category.id }
    }
  );

  if (loading) return 'Loading...';

  if (error) {
    if (error.message.includes("GraphQL error: Unauthorized")) {
      window.location = "/auth/login?returnTo=/budget"
      return "Unauthorized"
    } else if (error.message.includes("GraphQL error: Plaid auth required") || error.message.includes("the login details of this item have changed")) {
      return (
        < NewItem />
      )
    } else {
      return `Unidentified error: ${error.message}`;
    }
  }

  return (
    <Container>
      <Container fluid className="text-center">
        <h1 className="mt-4">{category.name} Spend</h1>
        <p>${formattedAmount(totalSpend)}</p>
      </Container>

      <Container fluid>
        <Col className="text-center">
          <ListGroup className="mt-3">
            {data.transactions.map(tx => {
              return (
                <ListGroup.Item key={tx.transactionId}>
                  <p>{tx.name}</p>
                  <p>${formattedAmount(tx.amount)}</p>
                  <p>{tx.date}</p>
                </ListGroup.Item>
              )
            })}
          </ListGroup>
        </Col>
      </Container>
    </Container>
  )
}

export default CategorizedTransactions;
