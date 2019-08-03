import gql from 'graphql-tag';

export const GET_TASKS = gql`
  query tasks {
    tasks {
      id
      text
      complete
    }
  }
`;

export const CREATE_TASK = gql`
  mutation createTask($input: NewTask!) {
    createTask(input: $input) {
      id
      text
      complete
    }
  }
`;
