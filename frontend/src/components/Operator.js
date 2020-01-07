import React, { Component } from 'react';

class Operator extends Component {
  constructor(props) {
    super(props);
    this.state = { loading: true, operator: {} }
  }

  async componentDidMount() {
    let response = await fetch(`http://localhost:1337/operators/${this.props.match.params.id}`)
    let data = await response.json()
    this.setState({
      loading: false,
      operator: data
    })
  }

  render() {
    if (!this.state.loading) {
      return (
          <div className="operatorInformation">
            <h2 className="operatorName"> Name: {this.state.operator.name}</h2>
            <h3 className="operatorAddress">Address: {this.state.operator.address}</h3>
            <h3 className="amountStaked">Amount Staked: {this.state.operator.amountStaked}</h3>
          </div>
      );
    }

    return (<h2>Waiting for API...</h2>);
  }
}

export default Operator;