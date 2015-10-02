###**
* @ngdoc service
* @name  BBAdmin.Services:ColorPalette
*
* @description
* Factory ColorPalette
*

###
angular.module('BBAdmin.Services').factory 'ColorPalette', () ->

  colors = [
    {primary: '#001F3F', secondary: '#80BFFF'} # Navy
    {primary: '#FF4136', secondary: '#800600'} # Red
    {primary: '#7FDBFF', secondary: '#004966'} # Aqua
    {primary: '#3D9970', secondary: '#163728'} # Olive
    {primary: '#85144B', secondary: '#EB7AB1'} # Maroon
    {primary: '#2ECC40', secondary: '#0E3E14'} # Green
    {primary: '#FF851B', secondary: '#663000'} # Orange
  ]

  ###**
  * @ngdoc method
  * @name setColors
  * @methodOf BBAdmin.Services:AdminClientService
  *
  * @description
  * Method setColors
  *
  * @param {object} models Info
  *
  * @returns {object} model.textColor
  ###
  setColors: (models) ->
    _.each models, (model, i) ->
      color = colors[i % colors.length]
      model.color = color.primary
      model.textColor = color.secondary

