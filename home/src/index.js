import './main.css';
import { Elm } from './Main.elm';

function getCookie(cname) {
  var name = cname + "=";
  var decodedCookie = decodeURIComponent(document.cookie);
  var ca = decodedCookie.split(';');
  for(var i = 0; i <ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}

Elm.Main.init({
  node: document.getElementById('root'),
  flags: {
    node_env: process.env.NODE_ENV,
    session: getCookie("home_session"),
  }
});
