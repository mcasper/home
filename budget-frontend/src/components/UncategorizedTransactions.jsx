import React from 'react';
import Container from 'react-bootstrap/Container';
import Col from 'react-bootstrap/Col';
import ListGroup from 'react-bootstrap/ListGroup';
import UncategorizedTransactionRow from './UncategorizedTransactionRow.jsx'

import { Query } from 'react-apollo';
import { GET_UNCATEGORIZED_TRANSACTIONS } from '../queries.js';

function UncategorizedTransactions(props) {
  return(
    <Query query={GET_UNCATEGORIZED_TRANSACTIONS}>
      {({ loading, error, data }) => {
        if (loading) return 'Loading...';
        if (error) return `Error! ${error.message}`;

        return(
          <Container>
            <Container fluid className="text-center">
              <h1 className="mt-4">Uncategorized Spend</h1>
              <p>Add categories to your purchases to get better insight into your spending habits</p>
            </Container>

            <Container fluid>
              <Col className="text-center">
                <ListGroup className="mt-3">
                  {data.transactions.map(tx => <UncategorizedTransactionRow key={tx.transactionId} transaction={tx} />)}
                </ListGroup>
              </Col>
            </Container>
          </Container>
        );
      }}
    </Query>
  )
}

export default UncategorizedTransactions;
