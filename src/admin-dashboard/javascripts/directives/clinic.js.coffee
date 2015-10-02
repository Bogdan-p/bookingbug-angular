###**
* @ngdoc directive
* @name BBAdminDashboard.Directives:bbClinicDashboard
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBAdminDashboard.Directives:bbClinicDashboard
*
* # Has the following set of methods:
*
* - controller 'bbClinicDashboardController'
*
* @requires $modal
* @requires $log
* @requires $rootScope
* @requires $compile
* @requires $templateCache
* @requires BB.Services:ModalForm
* @requires BB.Models:BBModel
*
###

angular.module('BBAdminDashboard').directive 'bbClinicDashboard', ($modal, $log,
  $rootScope, $compile, $templateCache, ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getClinicSetup()

  {
    link: link
    controller: 'bbClinicDashboardController'
  }

###**
* @ngdoc directive
* @name BBAdminDashboard.Directives:bbClinicCal
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBAdminDashboard.Directives:bbClinicCal
*
* # Has the following set of methods:
* -controller 'bbClinicCalController'
*
* @requires $modal
* @requires $log
* @requires $rootScope
* @requires $compile
* @requires $templateCache
* @requires BB.Services:ModalForm
* @requires BB.Models:BBModel
*
###


angular.module('BBAdminDashboard').directive 'bbClinicCal', ($modal, $log,
  $rootScope, $compile, $templateCache, ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getClinicCalSetup()

  {
    link: link
    controller: 'bbClinicCalController'
  }

###**
* @ngdoc directive
* @name BBAdminDashboard.Directives:bbClinic
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBAdminDashboard.Directives:bbClinic
*
* # Has the following set of methods:
* -controller 'bbClinicController'
*
* @requires $modal
* @requires $log
* @requires $rootScope
* @requires $compile
* @requires $templateCache
* @requires BB.Services:ModalForm
* @requires BB.Models:BBModel
*
###

angular.module('BBAdminDashboard').directive 'bbClinic', ($modal, $log,
  $rootScope, $compile, $templateCache, ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getClinicItemSetup()

  {
    link: link
    controller: 'bbClinicController'
  }