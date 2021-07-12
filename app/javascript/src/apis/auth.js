import axios from "axios";

const login = payload => axios.post("/sessions", payload);

const logout = () => axios.delete(`/sessions`);

const signup = payload => axios.post("/users", payload);

const authApi = {
  login,
  logout,
  signup,
};

export default authApi;
