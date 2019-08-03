import gql from 'graphql-tag';

export const GET_INCOMPLETE_TASKS = gql`
  query tasks {
    tasks(complete: false) {
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

export const UPDATE_TASK = gql`
  mutation updateTask($id: ID!, $input: TaskUpdate!) {
    updateTask(id: $id, input: $input) {
      id
      text
      complete
    }
  }
`;
