import React, { Component } from 'react';

class Budget extends Component {
  render() {
    return (
      <h2>Total: {this.props.budget.total}</h2>
    );
  }
}

export default Budget;
