###**
* @ngdoc controller
* @name BBQueue.Controllers:bbQueues
*
* @description
*{@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller bbQueues
*
* # Has the following set of methods:
*
* - $scope.getQueues()
*
* @requires $scope
* @requires $log
* @requires BBQueue.Services:AdminQueuerService
* @requires BB.Services:ModalForm
*
###

angular.module('BBQueue').controller 'bbQueues', ($scope, $log,
    AdminQueueService, ModalForm) ->

  $scope.loading = true

  ###**
  * @ngdoc method
  * @name $scope.getQueues
  * @methodOf BBQueue.Controllers:bbQueues
  * @description
  * 
  ### 

  $scope.getQueues = () ->
    params =
      company: $scope.company
    AdminQueueService.query(params).then (queues) ->
      $scope.queues = queues
      $scope.loading = false
    , (err) ->
      $log.error err.data
      $scope.loading = false


