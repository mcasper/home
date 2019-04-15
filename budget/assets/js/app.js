import css from '../css/app.css'
import 'phoenix_html'

import { Elm } from "../elm/src/CategorizeSpend.elm";
var categorizeSpendDiv = document.getElementById('elm-categorize-spend');
if (categorizeSpendDiv !== null) {
  Elm.Main.init({
    node: categorizeSpendDiv,
  });
}

// A really annoying function to take 1234567890 and turn it into 12,345,678.90
function splitString(string, size) {
  var pieces = string.split('').reverse();
  var result = [];
  var temp = [];
  var i;
  for (i = 0; i < pieces.length; i++) {
    if (i != 0 && (i + 1) % size == 0) {
      temp.push(pieces[i]);
      result.push(temp.reverse().join(''));
      temp = [];
    } else {
      temp.push(pieces[i]);
    }
  }

  if (temp.length > 0) {
    result.push(temp.reverse().join(''));
  }

  return result.reverse()
}

window.App = {
  formatPrice: function(input) {
    var value = input.value.replace(/\.|,/g, '');

    if (value.length > 5) {
      var decimals = value.substring(value.length - 2, value.length);
      var pieces = splitString(value.substring(0, value.length - 2), 3)

      value = [pieces.join(','), decimals].join('.')
    } else if (value.length > 2) {
      value = value.substring(0, value.length - 2) + '.' + value.substring(value.length - 2, value.length);
    }

    input.value = value;
  },
}
