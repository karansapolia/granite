import React, { useEffect, useState } from "react";
import { Route, Switch, BrowserRouter as Router } from "react-router-dom";
import { setAuthHeaders } from "./apis/axios";
import { initializeLogger } from "./common/logger";
import Dashboard from "components/Dashboard";
import CreateTask from "components/Tasks/CreateTask";

const App = () => {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    initializeLogger();
    setAuthHeaders(setLoading);
    // logger.info("Never use console.log");
    // logger.error("Never use console.error");
  }, []);

  return (
    <Router>
      <Switch>
        <Route exact path="/" render={() => <div>Home</div>} />
        <Route exact path="/about" render={() => <div>About</div>} />
        <Route exact path="/dashboard" component={Dashboard} />
        <Route exact path="/tasks/create" component={CreateTask} />
      </Switch>
    </Router>
  );
};

export default App;
