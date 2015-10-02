# centralise the static file paths as it makes it easier to chnage if needed.
###**
* @ngdoc service
* @name BB.Services:PathSvc
*
* @description
* Factory PathSvc
*
* @param {service} $sce $sce is a service that provides Strict Contextual Escaping services to AngularJS.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$sce more}
*
* @param {object} AppConfig Info
* <br>
* {@link AppConfig more}
*
* @returns {Promise} This service has the following set of methods:
*
* - directivePartial(fileName)
*
###
angular.module('BB.Services').factory 'PathSvc', ($sce, AppConfig) ->
  directivePartial : (fileName) ->
    if AppConfig.partial_url
      partial_url = AppConfig.partial_url
      $sce.trustAsResourceUrl("#{partial_url}/#{fileName}.html")
    else
      $sce.trustAsResourceUrl("#{fileName}.html")
