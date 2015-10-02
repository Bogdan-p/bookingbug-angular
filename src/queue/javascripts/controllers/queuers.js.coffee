###**
* @ngdoc controller
* @name BBQueue.Controllers:bbQueuers
*
* @description
*{@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller bbQueuers
*
* # Has the following set of methods:
*
* - $scope.getQueuers()
* - $scope.newQueuerModal()
*
* @requires $scope
* @requires $log
* @requires BBQueue.Services:AdminQueuerService
* @requires BB.Services:ModalForm
* @requires $interval
*
###

angular.module('BBQueue').controller 'bbQueuers', ($scope, $log,
    AdminQueuerService, ModalForm, $interval) ->

  $scope.loading = true

  ###**
  * @ngdoc method
  * @name $scope.getQueuers
  * @methodOf BBQueue.Controllers:bbQueuers
  * @description
  * 
  ### 

  $scope.getQueuers = () ->
    params =
      company: $scope.company
    AdminQueuerService.query(params).then (queuers) ->
      $scope.queuers = queuers
      $scope.waiting_queuers = []
      for queuer in queuers
        queuer.remaining()
        $scope.waiting_queuers.push(queuer) if queuer.position > 0

      $scope.loading = false
    , (err) ->
      $log.error err.data
      $scope.loading = false

  ###**
  * @ngdoc method
  * @name $scope.newQueuerModal
  * @methodOf BBQueue.Controllers:bbQueuers
  * @description
  * 
  ### 

  $scope.newQueuerModal = () ->
    ModalForm.new
      company: $scope.company
      title: 'New Queuer'
      new_rel: 'new_queuer'
      post_rel: 'queuers'
      success: (queuer) ->
        $scope.queuers.push(queuer)

  
    # this is used to retrigger a scope check that will update service time
  $interval(->
    if $scope.queuers
      for queuer in $scope.queuers
        queuer.remaining()
  , 5000)
