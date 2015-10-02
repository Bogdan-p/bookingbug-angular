###**
* @ngdoc service
* @name BB.Services:SettingsService
*
* @description
* Factory SettingsService
*
@returns {Promise} This service has the following set of methods:
*
* - enableInternationalizaton()
* - isInternationalizatonEnabled()
* - setScrollOffset()
* - getScrollOffset()
*
###
angular.module('BB.Services').factory 'SettingsService', () ->

  i18n = false
  scroll_offset = 0

  enableInternationalizaton: () ->
    i18n = true

  isInternationalizatonEnabled: () ->
    return i18n

  setScrollOffset: (value) ->
    scroll_offset = parseInt(value)

  getScrollOffset: () ->
    return scroll_offset
