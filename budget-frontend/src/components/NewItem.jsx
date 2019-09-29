import React from 'react';
import PlaidLink from 'react-plaid-link'
import { EXCHANGE_PLAID_TOKEN } from '../queries.js'
import { useMutation } from '@apollo/react-hooks';

function handleOnExit() {
  // handle the case when your user exits Link
}

function NewItem(props) {
  const [exchangePlaidToken, { _data }] = useMutation(EXCHANGE_PLAID_TOKEN);

  return (
    <div className="container-fluid text-center">
      <h1 className="mt-4">Budget</h1>
      <p>To get started, link your bank account</p>

      <PlaidLink
        clientName="Home Budget"
        env="sandbox"
        product={["transactions"]}
        publicKey="e911a93b41327bfb1d4493525167b2"
        onExit={handleOnExit}
        onSuccess={(token, metadata) => {
          exchangePlaidToken({ variables: { token: token } })
        }}
      >
        Link Account
        </PlaidLink>
    </div >
  )
}

export default NewItem;
