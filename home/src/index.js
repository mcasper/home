import './main.css';
import { Elm } from './Main.elm';

Elm.Main.init({
  node: document.getElementById('root'),
  flags: {
    node_env: process.env.NODE_ENV,
  }
});
