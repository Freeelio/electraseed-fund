import React, { Component } from 'react';
import { Link } from 'react-router-dom'

class ProjectList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      projects: []
    }
  }

  async componentDidMount() {
    let response = await fetch("http://localhost:1337/projects");
    if (!response.ok) {
      return
    }

    let projects = await response.json()
    this.setState({ loading: false, projects: projects })
  }

  render() {
    if (!this.state.loading) {
      return (
        <div className="ProjectList">
          <h2 className="ProjectList-title">Available Projects ({this.state.projects.length})</h2>
          <div className="ProjectList-container">
            {this.state.projects.map((project, index) => {
              return (
                <div className="ProjectList-project" key={project.id}>
                  <Link to={`/project/${project.id}`}>
                    <h3>{project.name}</h3>
                    <img src={`http://localhost:1337/${project.coverPicture[0].url}`} alt={project.name} />
                  </Link>
                </div>
              );
            })}
          </div>
        </div>
      );
    }

    return (<h2 className="ProjectList-title">Waiting for API...</h2>);
  }
}

export default ProjectList;