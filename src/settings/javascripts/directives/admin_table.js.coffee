###**
* @ngdoc directive
* @name BBAdminSettings.Directives:adminTable
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBAdminSettings.Directives:adminTable
*
* # Has the following set of methods:
*
* - controller($scope)
* - $scope.getAdministrators()
* - $scope.newAdministrator()
* - success(administrator)
* - $scope.edit(id)
* - link(scope, element, attrs)
*
* @requires BBAdmin.Services:AdminCompanyService
* @requires BBAdmin.Services:AdminAdministratorService
* @requires $modal
* @requires $log
* @requires BB.Services:ModalForm
*
###

angular.module('BBAdminSettings').directive 'adminTable', (AdminCompanyService,
    AdminAdministratorService, $modal, $log, ModalForm) ->

  controller = ($scope) ->

    $scope.getAdministrators = () ->
      params =
        company: $scope.company
      AdminAdministratorService.query(params).then (administrators) ->
        $scope.admin_models = administrators
        $scope.administrators = _.map administrators, (administrator) ->
          _.pick administrator, 'id', 'name', 'email', 'role'

    $scope.newAdministrator = () ->
      ModalForm.new
        company: $scope.company
        title: 'New Administrator'
        new_rel: 'new_administrator'
        post_rel: 'administrators'
        success: (administrator) ->
          $scope.administrators.push(administrator)

    $scope.edit = (id) ->
      admin = _.find $scope.admin_models, (p) -> p.id == id
      ModalForm.edit
        model: admin
        title: 'Edit Administrator'

  link = (scope, element, attrs) ->
    if scope.company
      scope.getAdministrators()
    else
      AdminCompanyService.query(attrs).then (company) ->
        scope.company = company
        scope.getAdministrators()

  {
    controller: controller
    link: link
    templateUrl: 'admin_table_main.html'
  }
