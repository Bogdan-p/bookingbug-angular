###**
* @ndgoc directive
* @name BBQueue.Directives:bbIfLogin
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBQueue.Directives:bbIfLogin
*
* # Has the following set of methods:
*
* - compile()
* - link(scope, element, attrs)
*
* @requires $modal
* @requires $log
* @requires $q
* @requires $rootScope
* @requires BBQueue.Services:AdminQueueService
* @requires BBAdmin.Services:AdminCompanyService
* @requires $compile
* @requires $templateCache
* @requires BB.Services:ModalForm
* @requires BB.Models:BBModel
*
###

angular.module('BBQueue').directive 'bbIfLogin', ($modal, $log, $q,
  $rootScope, AdminQueueService, AdminCompanyService, $compile, $templateCache,
  ModalForm, BBModel) ->

  compile = () ->
    {
      pre: ( scope, element, attributes ) ->
        @whenready = $q.defer()
        scope.loggedin = @whenready.promise
        AdminCompanyService.query(attributes).then (company) ->
          scope.company = company
          @whenready.resolve()
      ,
      post: ( scope, element, attributes ) ->
    }

  link = (scope, element, attrs) ->
  {
    compile: compile
#    controller: 'bbQueuers'
    # templateUrl: 'queuer_table.html'
  }

###**
* @ndgoc directive
* @name BBQueue.Directives:bbQueueDashboard
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBQueue.Directives:bbQueueDashboard
*
* # Has the following set of methods:
*
* - link(scope, element, attrs)
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

angular.module('BBQueue').directive 'bbQueueDashboard', ($modal, $log,
  $rootScope, $compile, $templateCache,
  ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getSetup()

  {
    link: link
    controller: 'bbQueueDashboardController'
  }

###**
* @ndgoc directive
* @name BBQueue.Directives:bbQueues
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBQueue.Directives:bbQueues
*
* # Has the following set of methods:
*
* - compile()
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

angular.module('BBQueue').directive 'bbQueues', ($modal, $log,
  $rootScope, $compile, $templateCache,
  ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getQueues()

  {
    link: link
    controller: 'bbQueues'
    # templateUrl: 'queuer_table.html'
  }

###**
* @ndgoc directive
* @name BBQueue.Directives:bbQueueServers
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBQueue.Directives:bbQueueServers
*
* # Has the following set of methods:
*
* - compile()
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

angular.module('BBQueue').directive 'bbQueueServers', ($modal, $log,
  $rootScope, $compile, $templateCache,
  ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.loggedin.then () ->
      scope.getServers()

  {
    link: link
    controller: 'bbQueueServers'
    # templateUrl: 'queuer_table.html'
  }
