const path = require('path');
const { merge } = require('webpack-merge');

const common = require('./webpack.config.common.js');

module.exports = merge(common, {
  mode: 'development',
  devtool: 'eval-cheap-source-map',
  devServer: {
    before(app, server) {
      server._watch(path.resolve(__dirname, '../**/*.html'));
      server._watch(path.resolve(__dirname, '../**/*.py'));
    },
    inline: true,
    hot: true,
    contentBase: [
      path.resolve(__dirname, '../build/js'),
      path.resolve(__dirname, '../build/styles'),
    ],
    proxy: [
      {
        context: ['**', '!/static/js/**', '!/static/styles/**'],
        target: 'http://localhost:8000',
        changeOrigin: true,
        watchContentBase: true,
      },
    ],
  },
});
