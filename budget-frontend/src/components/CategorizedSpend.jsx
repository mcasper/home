import React, { useState } from 'react';
import Container from 'react-bootstrap/Container';
import ListGroup from 'react-bootstrap/ListGroup';
import NewItem from './NewItem.jsx';
import CategorizedTransactions from './CategorizedTransactions.jsx';

import { useQuery } from '@apollo/react-hooks';
import { GET_CATEGORIZED_SPEND } from '../queries.js';

import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";

function defaultFrom() {
  var date = new Date();
  date.setDate(date.getDate() - 30)
  return date.toISOString()
}

function formattedAmount(amount) {
  var roundedNumber = Number((amount).toFixed(2)).toString();
  var parts = roundedNumber.split(".");
  while (parts[1].length < 2) {
    parts[1] = parts[1] + "0";
  }
  return parts.join(".")
}

function CategorizedSpend(props) {
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
    <Router>
      <Switch>
        <Route exact path="/budget">
          <Container>
            <Container fluid className="text-center">
              <h1 className="mt-4">All transactions categorized!</h1>

              <ListGroup>
                {data.categorizedSpend.map(spend => {
                  return (
                    <Link to={`/budget/categories/${spend.category.name}`} style={{ textDecoration: "none", color: "black" }} key={spend.category.name}>
                      <ListGroup.Item key={spend.category.name}>
                        <p><b>{spend.category.name}</b></p>
                        <p>{formattedAmount(spend.amount)}</p>
                      </ListGroup.Item>
                    </Link>
                  )
                })}
              </ListGroup>
            </Container>
          </Container>
        </Route>

        {data.categorizedSpend.map(spend => {
          return (
            <Route path={`/budget/categories/${spend.category.name}`} key={`${spend.category.name}-route`}>
              <CategorizedTransactions />
            </Route>
          )
        })}
      </Switch>
    </Router>
  );
}

export default CategorizedSpend;