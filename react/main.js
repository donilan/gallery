import React from 'react';
import ReactDOM from 'react-dom';
import Loading from './loading';
import injectTapEventPlugin from 'react-tap-event-plugin';
injectTapEventPlugin();

require("./styles/app.scss");

var container = document.getElementById('outlet');
/* ReactDOM.render(<Loading />, container); */
require(['./gallery'], function(Gallery){
  ReactDOM.render(<Gallery />, container);
})
