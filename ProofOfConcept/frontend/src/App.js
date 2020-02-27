import React from 'react';
import './App.css';
import { Route, Switch } from "react-router";
import { Link } from 'react-router-dom';
import ProjectList from "./components/ProjectList";
import Project from "./components/Project";
import Crowdsale from "./components/Crowdsale";
import Operator from "./components/Operator";
import OperatorList from "./components/OperatorList";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <ul>
        <li><Link to="/operators">Operator TCR</Link></li>
        <li><Link to="/">Project TCR</Link></li>
        <li><Link to="/crowdsales/1">Crowdsale</Link></li>
        </ul>

      </header>
      <main className="App-content">
          <Switch>
            <Route path="/" exact component={ProjectList} />
            <Route path="/project/:id" component={Project} />
            <Route path="/crowdsales/1" component={Crowdsale} />
            <Route path="/operators" component={OperatorList} />
            <Route path="/operator/:id" component={Operator} />
          </Switch>
      </main>
    </div>
  );
}

export default App;





