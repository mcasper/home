import React, { useState } from 'react';
import Container from 'react-bootstrap/Container';
import ListGroup from 'react-bootstrap/ListGroup';
import NewItem from './NewItem.jsx'

import { useQuery } from '@apollo/react-hooks';
import { GET_CATEGORIZED_SPEND } from '../queries.js';

function defaultFrom() {
  var date = new Date();
  date.setDate(date.getDate() - 30)
  return date.toISOString()
}

function EmptyUncategorizedTransactions(props) {
  const [from, _setFrom] = useState(defaultFrom());
  const { loading, error, data } = useQuery(
    GET_CATEGORIZED_SPEND,
    {
      variables: { from }
    }
  );

  if (loading) return 'Loading...';

  if (error) {
    if (error.message === "GraphQL error: Unauthorized") {
      window.location = "/auth/login?returnTo=/budget"
      return "Unauthorized"
    } else if (error.message === "GraphQL error: Plaid auth required") {
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
        <h1 className="mt-4">All transactions categorized!</h1>

        <ListGroup>
          {data.categorizedSpend.map(spend => {
            return (
              <a style={{ textDecoration: "none", color: "black" }} key={spend.category.name} href="#">
                <ListGroup.Item key={spend.category.name}>
                  <p><b>{spend.category.name}</b></p>
                  <p>{spend.amount}</p>
                </ListGroup.Item>
              </a>
            )
          })}
        </ListGroup>
      </Container>
    </Container >
  );
}

export default EmptyUncategorizedTransactions;
