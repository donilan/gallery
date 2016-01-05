var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: [
    __dirname + '/react/main.js'
  ],
  output: {
    path: __dirname + '/public/javascripts/',
    publicPath: '/javascripts/',
    filename: 'app.js'
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /(node_modules)/,
        loader: 'babel',
        query: {
          presets: ['react', 'es2015']
        }
      },
      {
        test: /\.scss$/,
        loaders: ["style", "css", "sass"]
      }
    ]
  }
};
