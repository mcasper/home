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

export const GET_CATEGORIES = gql`
  query categories {
    categories {
      name
      id
    }
  }
`

export const GET_CATEGORIES_AND_UNCATEGORIZED_TRANSACTIONS = gql`
  query categoriesAndTransactions {
    categories {
      id
      name
    }

    transactions {
      amount
      date
      name
      transactionId
    }
  }
`

export const CATEGORIZE_TRANSACTION = gql`
  mutation categorizeTransaction($originId: String!, $categoryId: ID!) {
    createCategorizedTransaction(originId: $originId, categoryId: $categoryId) {
      originId
    }
  }
`

export const GET_CATEGORIZED_SPEND = gql`
  query categorizedSpend($from: String!) {
    categorizedSpend(from: $from) {
      amount
      category {
        name
        id
      }
    }
  }
`

export const CREATE_CATEGORY = gql`
  mutation createCategory($name: String!) {
    createCategory(name: $name) {
      id
      name
    }
  }
`

export const GET_CATEGORIZED_TRANSACTIONS = gql`
  query transactions($categoryId: ID!) {
    transactions(categoryId: $categoryId) {
      amount
      date
      name
      transactionId
    }
  }
`
