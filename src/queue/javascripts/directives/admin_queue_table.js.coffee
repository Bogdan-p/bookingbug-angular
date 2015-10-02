###**
* @ndgoc directive
* @name BBQueue.Directives:bbAdminQueueTable
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBQueue.Directives:bbAdminQueueTable
*
* # Has the following set of methods:
*
* - link(scope, element, attrs)
*
* @requires $modal
* @requires $log
* @requires $rootScope
* @requires BBQueue.Services:AdminQueueService
* @requires BBAdmin.Services:AdminCompanyService
* @requires $compile
* @requires $templateCache
* @requires BB.Services:ModalForm
* @requires BB.Models:BBModel
*
### 

angular.module('BBQueue').directive 'bbAdminQueueTable', ($modal, $log,
  $rootScope, AdminQueueService, AdminCompanyService, $compile, $templateCache,
  ModalForm, BBModel) ->

  link = (scope, element, attrs) ->
    scope.fields ||= ['ticket_number', 'first_name', 'last_name', 'email']
    if scope.company
      scope.getQueuers()
    else
      AdminCompanyService.query(attrs).then (company) ->
        scope.company = company
        scope.getQueuers()

  {
    link: link
    controller: 'bbQueuers'
    templateUrl: 'queuer_table.html'
  }
