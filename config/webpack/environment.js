const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Selectpicker: 'bootstrap-select/dist/js/bootstrap-select.min.js'
  })
)

module.exports = environment
