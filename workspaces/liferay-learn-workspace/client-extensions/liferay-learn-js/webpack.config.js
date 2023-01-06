const path = require('path');

module.exports = {
	entry: './src/index.js',
    module: {
        rules: [
            {
              test: /\.js$/,
              exclude: /node_modules/,
              use: {
                loader: 'babel-loader',
                options: {
                  presets: ['@babel/preset-env']
                }
              }
            },          
            {
              test: /\.css$/,
              use: [{ loader: 'style-loader' }, { loader: 'css-loader' }],
            }
        ]
    },
    output: {
		filename: 'index.js',
		globalObject: 'this',
		path: path.resolve(__dirname, 'build/static')
	},
    mode: 'development'
};