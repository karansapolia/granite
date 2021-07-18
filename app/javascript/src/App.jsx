import React, { useEffect, useState } from "react";
import { Route, Switch, BrowserRouter as Router } from "react-router-dom";
import { ToastContainer } from "react-toastify";
import { either, isEmpty, isNil } from "ramda";

import { initializeLogger } from "./common/logger";
import Dashboard from "components/Dashboard";
import CreateTask from "components/Tasks/CreateTask";
import { registerIntercepts, setAuthHeaders } from "apis/axios.js";
import ShowTask from "components/Tasks/ShowTask";
import EditTask from "components/Tasks/EditTask";
import Signup from "components/Authentication/Signup";
import Login from "components/Authentication/Login";
import PrivateRoute from "components/Common/PrivateRoute";
import { getFromLocalStorage } from "./helpers/storage";
import PageLoader from "components/PageLoader";
import MyPreferences from "components/MyPreferences";

const App = () => {
  const [loading, setLoading] = useState(true);
  const authToken = getFromLocalStorage("authToken");
  const isLoggedIn = !either(isNil, isEmpty)(authToken) && authToken !== "null";

  useEffect(() => {
    initializeLogger();
    registerIntercepts();
    setAuthHeaders(setLoading);
    // logger.info("Never use console.log");
    // logger.error("Never use console.error");
  }, []);

  if (loading) {
    return (
      <div className="h-screen">
        <PageLoader />
      </div>
    );
  }

  return (
    <Router>
      <ToastContainer />
      <Switch>
        <Route exact path="/tasks/:slug/show" component={ShowTask} />
        <Route exact path="/tasks/:slug/edit" component={EditTask} />
        <Route exact path="/tasks/create" component={CreateTask} />
        <Route exact path="/signup" component={Signup} />
        <Route exact path="/login" component={Login} />
        <Route exact path="/my/preferences" component={MyPreferences} />
        <PrivateRoute
          path="/"
          redirectRoute="/login"
          condition={isLoggedIn}
          component={Dashboard}
        />
      </Switch>
    </Router>
  );
};

export default App;
