###**
* @ngdoc controller
* @name BBAdminDashboard.Controllers:bbClinicDashboardController
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller bbClinicDashboardCtrl
*
* # Has the following set of methods:
* - $scope.getClinicSetup()
*
* @requires $scope 
* @requires $log
* @requires BBAdmin.Services:AdminServiceService
* @requires BBAdmin.Services:AdminResourceService
* @requires BBAdmin.Services:AdminPersonService
* @requires BB.Services:ModalForm
* @requires BB.Models:BBModel
* @requires $interval
* @requires $sessionStorage
*
###
angular.module('BBAdminDashboard').controller 'bbClinicDashboardController', ($scope, $log,
    AdminServiceService, AdminResourceService, AdminPersonService, ModalForm, BBModel, $interval, $sessionStorage) ->

  $scope.loading = true

  $scope.getClinicSetup = () ->
    console.log "setup"
    params =
      company: $scope.company
    AdminServiceService.query(params).then (services) ->
      $scope.services = services
    , (err) ->
      $log.error err.data

    AdminResourceService.query(params).then (resources) ->
      $scope.resources = resources
    , (err) ->
      $log.error err.data

    AdminPersonService.query(params).then (people) ->
      $scope.people = people
    , (err) ->
      $log.error err.data
