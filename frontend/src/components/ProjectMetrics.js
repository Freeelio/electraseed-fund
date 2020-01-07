import React, { Component } from 'react';

class ProjectMetrics extends Component {
  constructor(props) {
    super(props);

    this.state = {
        loading: true,
        projectMetrics: {}
    };
  }

  async componentDidMount() {
    let response = await fetch(`http://localhost:1337/project-metrics/${this.props.match.params.id}`)
    let data = await response.json()
    this.setState({
      loading: false,
      projectMetrics: data
    })
  }

  render() {
    if (!this.state.loading) {
      return (
        <div className="projectMetrics">
            <h3>PROJECTS METRICS REPORTED</h3>
            <table className="projectMetricsTable">
                <thead>
                    <tr>
                        <th>Metric</th>
                        <th>Value</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th>Size PV</th>
                        <td>{this.state.projectMetrics.sizePV}</td>
                    </tr>
                    <tr>
                        <th>Storage Count</th>
                        <td>{this.state.projectMetrics.storageCount}</td>
                    </tr>
                    <tr>
                        <th>Storage Type</th>
                        <td>{this.state.projectMetrics.storageType}</td>
                    </tr>
                    <tr>
                        <th>Storage Capacity</th>
                        <td>{this.state.projectMetrics.storageCapacity}</td>
                    </tr>
                    <tr>
                        <th>Avg. Generation Capacity</th>
                        <td>{this.state.projectMetrics.avgGenerationCapacity}</td>
                    </tr>
                    <tr>
                        <th>Available Daytime Capacity</th>
                        <td>{this.state.projectMetrics.availDaytimeCapacity}</td>
                    </tr>
                    <tr>
                        <th>Available Nighttime Capacity</th>
                        <td>{this.state.projectMetrics.availNighttimeCapacity}</td>
                    </tr>
                    <tr>
                        <th>Modules Count</th>
                        <td>{this.state.projectMetrics.modulesCount}</td>
                    </tr>
                    <tr>
                        <th>Modules Type</th>
                        <td>{this.state.projectMetrics.modulesType}</td>
                    </tr>
                    <tr>
                        <th>Nominal Power</th>
                        <td>{this.state.projectMetrics.nominalPower}</td>
                    </tr>
                    <tr>
                        <th>PV Inverter Count</th>
                        <td>{this.state.projectMetrics.pvInverterCount}</td>
                    </tr>
                    <tr>
                        <th>Battery Inverter Type</th>
                        <td>{this.state.projectMetrics.batteryInverterType}</td>
                    </tr>
                    <tr>
                        <th>Battery Inverter Count</th>
                        <td>{this.state.projectMetrics.batteryInverterCount}</td>
                    </tr>
                    <tr>
                        <th>Monitoring Count</th>
                        <td>{this.state.projectMetrics.monitoringCount}</td>
                    </tr>
                    <tr>
                        <th>Monitoring Type</th>
                        <td>{this.state.projectMetrics.monitoringType}</td>
                    </tr>
                    <tr>
                        <th>CO2 Avoidance</th>
                        <td>{this.state.projectMetrics.avoidanceCO2}</td>
                    </tr>
                    <tr>
                        <th>Household Count</th>
                        <td>{this.state.projectMetrics.householdCount}</td>
                    </tr>
                    <tr>
                        <th>Connection Count</th>
                        <td>{this.state.projectMetrics.connectionCount}</td>
                    </tr>
                    <tr>
                        <th>Social ROI</th>
                        <td>{this.state.projectMetrics.socialROI}</td>
                    </tr>

                </tbody>
                </table>
        </div>
      );
    }

    return (<h2>Waiting for API...</h2>);
  }
}

export default ProjectMetrics;