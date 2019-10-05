import React from 'react';
import Container from 'react-bootstrap/Container';
import Col from 'react-bootstrap/Col';
import ListGroup from 'react-bootstrap/ListGroup';
import UncategorizedTransactionRow from './UncategorizedTransactionRow.jsx';
import NewItem from './NewItem.jsx';
import NewCategory from './NewCategory.jsx';
import CategorizedSpend from './CategorizedSpend';

import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";

import { useQuery } from '@apollo/react-hooks';
import { GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS } from '../queries.js';

function UncategorizedTransactions(props) {
  const { loading, error, data } = useQuery(GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS);

  if (loading) return 'Loading...';

  if (error) {
    if (error.message.includes("GraphQL error: Unauthorized")) {
      window.location = "/auth/login?returnTo=/budget"
      return "Unauthorized"
    } else if (error.message.includes("GraphQL error: Plaid auth required")) {
      return (
        < NewItem />
      )
    } else {
      return `Unidentified error: ${error.message}`;
    }
  }

  if (data.transactions.length === 0) {
    return <CategorizedSpend />
  } else {
    return (
      <Router>
        <Switch>
          <Route exact path="/budget">
            <Container>
              <Container fluid className="text-center">
                <h1 className="mt-4">Uncategorized Spend</h1>
                <p>Add categories to your purchases to get better insight into your spending habits</p>
                <Link to="/budget/categories/new">New Category</Link>
              </Container>

              <Container fluid>
                <Col className="text-center">
                  <ListGroup className="mt-3">
                    {data.transactions.map(tx => <UncategorizedTransactionRow key={tx.transactionId} transaction={tx} categories={data.categories} />)}
                  </ListGroup>
                </Col>
              </Container>
            </Container>
          </Route>
        </Switch>

        <Switch>
          <Route path="/budget/categories/new">
            <NewCategory />
          </Route>
        </Switch>
      </Router>
    );
  }
}

export default UncategorizedTransactions;
