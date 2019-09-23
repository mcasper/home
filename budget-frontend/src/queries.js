import gql from 'graphql-tag';

export const GET_UNCATEGORIZED_TRANSACTIONS = gql`
  query transactions {
    transactions {
      amount
      date
      name
      transactionId
    }
  }
`;

export const EXCHANGE_PLAID_TOKEN = gql`
  mutation exchangePlaidToken($token: String!) {
    exchangePlaidToken(token: $token)
  }
`
