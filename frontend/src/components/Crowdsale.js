import React, { Component } from 'react';
import { Link } from 'react-router-dom'
import payWithMetamask from "./EthButton";

class Crowdsale extends Component {
  constructor(props) {
    super(props);

    this.state = {
        loading: true,
        contractAddress: 0,
        startDate: 0,
        endDate: 0,
        minContribution: 0,
        amountRaised: 0,
        isRunning: false,
        isFunded: false,
        projectsListed: []
    };
  }

  async componentDidMount() {
    let response = await fetch(`http://localhost:1337/crowdsales/1`)
    let data = await response.json()
    this.setState({
      loading: false,
      contractAddress: data.contractAddress,
      startDate: data.startDate,
      endDate: data.endDate,
      minContribution: data.minContribution,
      amountRaised: data.amountRaised,
      isRunning: data.isRunning,
      isFunded: data.isFunded,
      projectsListed: data.projectsListed
    })
  }

  render() {
    if (!this.state.loading) {
      return (
        <div className="crowdsale">
          <div className="crowdsaleInformation">
            <h2 className="contractAddress"> Contract Address: {this.state.contractAddress}</h2>
            <h3 className="startDate">Start Date: {new Date(this.state.startDate).toLocaleDateString()}</h3>
            <h3 className="endDate">End Date: {new Date(this.state.endDate).toLocaleDateString()}</h3>
            <h3 className="minContribution">Minimum Contribution: {this.state.minContribution} Eth</h3>
            <h3 className="amountRaised">Amount Raised: {this.state.amountRaised}</h3>
            <h3 className="isRunning">{this.state.isRunning}</h3>
            <h3 className="isFunded">{this.state.isFunded}</h3>
            <h3>PROJECTS LISTED IN THIS SALE</h3>
            <table className="projectsListed">
                <thead>
                    <tr>
                        <th>Project ID</th>
                        <th>Name</th>
                        <th>Amount Requested</th>
                        <th>Social ROI</th>
                    </tr>
                </thead>
                <tbody>
                {
                    this.state.projectsListed.map(project => (
                        <tr key={project.id}>
                            <th><Link to={`/project/${project.id}`}>{project.id}</Link></th>
                            <td>{project.name}</td>
                            <td>{project.amountRequested}</td>
                            <td>{project.socialROI}</td>
                        </tr>
                    ))
                }
                </tbody>
            </table>
          </div>
          <div>
              You can make a contribution to the crowdsale without signaling the voter's preference.
          </div>
          <button onClick={() => payWithMetamask("10.00")} className="btn btn-primary">Contribute 10 Eth</button>
        </div>
      );
    }

    return (<h2>Waiting for API...</h2>);
  }
}

export default Crowdsale;