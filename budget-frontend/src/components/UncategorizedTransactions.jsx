import React from 'react';
import Container from 'react-bootstrap/Container';
import Col from 'react-bootstrap/Col';
import ListGroup from 'react-bootstrap/ListGroup';
import UncategorizedTransactionRow from './UncategorizedTransactionRow.jsx'

function UncategorizedTransactions(props) {
  let txs = [{amount: 100.00, name: "Uber", date: "2017-08-09", transaction_id: "1"}, {amount: 200.00, name: "Uber", date: "2017-08-09", transaction_id: "2"}];
  return(
    <Container>
      <Container fluid className="text-center">
        <h1 className="mt-4">Uncategorized Spend</h1>
        <p>Add categories to your purchases to get better insight into your spending habits</p>
      </Container>

      <Container fluid>
        <Col className="text-center">
          <ListGroup className="mt-3">
            {txs.map(tx => <UncategorizedTransactionRow key={tx.transaction_id} transaction={tx} />)}
          </ListGroup>
        </Col>
      </Container>
    </Container>
  )
}

export default UncategorizedTransactions;
