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
