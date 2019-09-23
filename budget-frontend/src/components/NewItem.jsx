import React from 'react';
import PlaidLink from 'react-plaid-link'

class NewItem extends React.Component {
  handleOnSuccess(token, metadata) {
    // send token to client server
  }

  handleOnExit() {
    // handle the case when your user exits Link
  }

  render() {
    return (
      <div className="container-fluid text-center">
        <h1 className="mt-4">Budget</h1>
        <p>To get started, link your bank account</p>

        <PlaidLink
          clientName="Home Budget"
          env="sandbox"
          product={["transactions"]}
          publicKey="e911a93b41327bfb1d4493525167b2"
          onExit={this.handleOnExit}
          onSuccess={this.handleOnSuccess}>
          Link Account
        </PlaidLink>
      </div>
    )
  }
}

export default NewItem;
