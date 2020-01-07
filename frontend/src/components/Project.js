import React, { Component } from 'react';
import payWithMetamask from "./EthButton";

class Project extends Component {
  constructor(props) {
    super(props);

    this.state = { loading: true, project: {} }
  }

  async componentDidMount() {
    let response = await fetch(`http://localhost:1337/projects/${this.props.match.params.id}`)
    let data = await response.json()
    this.setState({
      loading: false,
      project: data
    })
  }

  render() {
    if (!this.state.loading) {
      return (
        <div className="project">
          <div className="projectInformation">
            <h2 className="projectName">Project Name: {this.state.project.name}</h2>
            <img src={`http://localhost:1337/${this.state.project.coverPicture[0].url}`} alt={this.state.project.name}/>
            <h3 className="projectOperator">Operator: {this.state.project.operatorId.name}</h3>
            <h3 className="amountRequested">Amount Requested: {this.state.project.amountRequested}</h3>
            <h3 className="gridType">Grid Type: {this.state.project.gridType}</h3>
            <h3 className="gridModel">Grid Model: {this.state.project.gridModel}</h3>
            <h3 className="businessModel">Operating Model: {this.state.project.businessModel}</h3>
            <h3 className="estimatedHousehold">Userbase: {this.state.project.householdCount}</h3>
            <h3 className="avoidanceCO2">CO2 Avoidance: {this.state.project.avoidanceCO2}</h3>
            <h3 className="sizePV">Size PV: {this.state.project.sizePV}</h3>
            <h3 className="socialROI">Social Impact Score: {this.state.project.socialROI}</h3>
          </div>
          <div className="projectDescription">
            <h3>Project Description: {this.state.project.description}</h3>
            <p>
              You can make a contribution to any project listed in the Curated Registry and it will be counted as a vote
              signaling the voter's preference.
            </p>
            <button onClick={() => payWithMetamask("10.00")} className="btn btn-primary">Vote for this Project</button>
          </div>
        </div>
      );
    }

    return (<h2>Waiting for API...</h2>);
  }
}

export default Project;