import React, { Component } from 'react';
import Budget from "./Budget.js";
import axios from "axios";
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {budget: {total: undefined}}
  }

  componentDidMount() {
    axios
      .get("http://localhost:9000/")
      .then((response) => {
        console.log(response.data)
        this.setState({
          budget: response.data
        })
      }).catch((error) => {
        console.log(error)
      });
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <h1>Casper Monthly Budget</h1>
          <Budget budget={this.state.budget}/>
        </header>
      </div>
    );
  }
}

export default App;
