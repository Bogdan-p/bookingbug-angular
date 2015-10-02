###**
* @ngdoc service
* @name BB.Services:LocaleService
*
* @description
* Factory BB.Services:LocaleService
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @returns {Promise} This service has the following set of methods:
*
###
angular.module('BB.Services').factory 'LocaleService', ($window) ->

  locale = $window.getURIparam('locale')

  if locale
    return locale
  else if $window.navigator.language
    return $window.navigator.language
  else
    # US a default locale
    return "en"
