import React, { Component } from 'react';
import { Link } from 'react-router-dom'

class OperatorList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      operators: []
    }
  }

  async componentDidMount() {
    let response = await fetch("http://localhost:1337/operators");
    if (!response.ok) {
      return
    }

    let operators = await response.json()
    this.setState({ loading: false, operators: operators })
  }

  render() {
    if (!this.state.loading) {
      return (
        <div className="operatorList">
          <h2 className="operatorListTitle">Available Operators ({this.state.operators.length})</h2>
          <div className="operatorListContainer">
            {this.state.operators.map((operator, index) => {
              return (
                <div className="operatorListOperator" key={operator.id}>
                  <Link to={`/operator/${operator.id}`}>
                    <h3>{operator.name}</h3>
                  </Link>
                </div>
              );
            })}
          </div>
        </div>
      );
    }

    return (<h2 className="operatorListTitle">Waiting for API...</h2>);
  }
}

export default OperatorList;