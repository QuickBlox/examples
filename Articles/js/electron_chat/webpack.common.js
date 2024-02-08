const path = require('path');
const webpack = require("webpack");

module.exports = {
    mode: 'development',
    entry: './src/js/index.js',
    devtool: 'inline-source-map',
    target: 'electron-renderer',
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [[
                            '@babel/preset-env', {
                                targets: {
                                    esmodules: true
                                }
                            }],
                            '@babel/preset-react']
                    }
                }
            },
            {
                test: [/\.s[ac]ss$/i, /\.css$/i],
                use: [
                    // Creates style nodes from JS strings
                    'style-loader',
                    // Translates CSS into CommonJS
                    'css-loader',
                    // Compiles Sass to CSS
                    'sass-loader',
                ],
            }
        ]
    },
    plugins: [
        new webpack.ProvidePlugin({
            adapter: ['webrtc-adapter', 'default'],
            // QB: path.resolve(__dirname, 'quickblox.js'),
            // QBVideoConferencingClient: path.resolve(
            //     __dirname,
            //     'quickblox-multiparty-video-conferencing-client-0.8.8.js'
            // )
        }),
        new webpack.ProgressPlugin()
    ],
    resolve: {
        extensions: ['.js'],
    },
    output: {
        filename: 'app.js',
        path: path.resolve(__dirname, 'build', 'js'),
    },
};
