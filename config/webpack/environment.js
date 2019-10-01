const { environment } = require('@rails/webpacker')
const webpack = require("webpack")

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)

environment.loaders.append("bootstrap.native", {
  test: /bootstrap\.native/,
  use: {
    loader: "bootstrap.native-loader",
    options: {
      only: ["alert", "button", "dropdown", "modal", "tooltip"],
      bsVersion: 4
    }
  }
})

module.exports = environment
