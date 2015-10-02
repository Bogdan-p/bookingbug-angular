###**
* @ngdoc controller
* @name BBQueue.Controllers:bbQueueDashboardController
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller bbQueueDashboardController
*
* # Has the following set of methods:
*
* - $scope.getSetup()
* - $scope.getQueuers()
* - $scope.overTrash(event, ui, set)
*   - $scope.hoverOver(event, ui, obj, set)
* - $scope.dropQueuer(event, ui, server, trash)
* - $scope.selectQueuer(queuer)
* - $scope.selectDragQueuer(queuer)
* - $scope.addQueuer(service)
* - $scope.pusherSubscribe()
*   - pusherEvent(res)
*
* @requires $scope
* @requires $log
* @requires BBAdmin.Services:AdminServiceService
* @requires BBQueue.Services:AdminQueuerService
* @requires BB.Services:ModalForm
* @requires BB.Models:BBModel
* @requires $interval
* @requires $sessionStorage
*
###

angular.module('BBQueue').controller 'bbQueueDashboardController', ($scope, $log,
    AdminServiceService, AdminQueuerService, ModalForm, BBModel, $interval, $sessionStorage) ->

  $scope.loading = true
  $scope.waiting_for_queuers = false
  $scope.queuers = []
  $scope.new_queuer = {}

  ###**
  * @ngdoc method
  * @name $scope.getSetup
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  * params =
  *   company: $scope.company
  * AdminServiceService.query(params).then (services) ->
  *   ...
  * </pre>
  *
  ###

  $scope.getSetup = () ->
    params =
      company: $scope.company
    AdminServiceService.query(params).then (services) ->
      $scope.services = []
      for service in services
        $scope.services.push(service) if !service.queuing_disabled
      $scope.loading = false
    , (err) ->
      $log.error err.data
      $scope.loading = false
    $scope.pusherSubscribe();
    $scope.getQueuers();

  ###**
  * @ngdoc method
  * @name $scope.getQueuers
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  *  return if $scope.waiting_for_queuers
  * $scope.waiting_for_queuers = true
  * params =
  *   ...
  * </pre>
  *
  ###  

  $scope.getQueuers = () ->
    return if $scope.waiting_for_queuers
    $scope.waiting_for_queuers = true
    params =
      company: $scope.company
    AdminQueuerService.query(params).then (queuers) ->
      $scope.queuers = queuers
      $scope.waiting_queuers = []
      for queuer in queuers
        queuer.remaining()
        $scope.waiting_queuers.push(queuer) if queuer.position > 0

      $scope.loading = false
      $scope.waiting_for_queuers = false
    , (err) ->
      $log.error err.data
      $scope.loading = false
      $scope.waiting_for_queuers = false

  ###**
  * @ngdoc method
  * @name $scope.overTrash
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  *   $scope.$apply () ->
  *   $scope.trash_hover = set
  * </pre>
  *
  ###  

  $scope.overTrash = (event, ui, set) ->
    $scope.$apply () ->
      $scope.trash_hover = set

  ###**
  * @ngdoc method
  * @name $scope.hoverOver
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  *  console.log event, ui, obj, set
  *  $scope.$apply () ->
  *   obj.hover = set     
  * </pre>
  *
  ###  

  $scope.hoverOver = (event, ui, obj, set) ->
    console.log event, ui, obj, set
    $scope.$apply () ->
      obj.hover = set

  ###**
  * @ngdoc method
  * @name $scope.dropQueuer
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  *  if $scope.drag_queuer
  *   if trash
  *     $scope.trash_hover = false
  *     ...
  * </pre>
  *
  ###       

  $scope.dropQueuer = (event, ui, server, trash) ->
    if $scope.drag_queuer
      if trash
        $scope.trash_hover = false
        $scope.drag_queuer.$del('self').then (queuer) ->

      if server
        $scope.drag_queuer.startServing(server).then () ->

  ###**
  * @ngdoc method
  * @name $scope.selectQueuer
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  *  if $scope.selected_queuer && $scope.selected_queuer == queuer
  *    $scope.selected_queuer = null
  *  else
  *  ...
  * </pre>
  *
  ###      

  $scope.selectQueuer = (queuer) ->
    if $scope.selected_queuer && $scope.selected_queuer == queuer
      $scope.selected_queuer = null
    else
      $scope.selected_queuer = queuer    

  ###**
  * @ngdoc method
  * @name $scope.selectDragQueuer
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  *  $scope.drag_queuer = queuer 
  * </pre>
  *
  ###      

  $scope.selectDragQueuer = (queuer) ->
    $scope.drag_queuer = queuer 

  ###**
  * @ngdoc method
  * @name $scope.addQueuer
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  *  $scope.new_queuer.service_id = service.id
  *  service.$post('queuers', {}, $scope.new_queuer).then (queuer) -> 
  * </pre>
  *
  ###     

  $scope.addQueuer = (service) ->
    $scope.new_queuer.service_id = service.id
    service.$post('queuers', {}, $scope.new_queuer).then (queuer) ->

  ###**
  * @ngdoc method
  * @name $scope.pusherSubscribe
  * @methodOf BBQueue.Controllers:bbQueueDashboardController
  * @description
  * <pre>
  *  if $scope.company? && Pusher?
  *   if !$scope.pusher?
  *     $scope.pusher = new Pusher 'c8d8cea659cc46060608',
  *       ...
  * </pre>
  *
  ###     

  $scope.pusherSubscribe = () =>
    if $scope.company? && Pusher?
      if !$scope.pusher?
        $scope.pusher = new Pusher 'c8d8cea659cc46060608',
          authEndpoint: "/api/v1/push/#{$scope.company.id}/pusher.json"
          auth:
            headers:
              # These should be put somewhere better - any suggestions?
              'App-Id' : 'f6b16c23'
              'App-Key' : 'f0bc4f65f4fbfe7b4b3b7264b655f5eb'
              'Auth-Token' : $sessionStorage.getItem('auth_token')
      
      channelName = "mobile-queue-#{$scope.company.id}"
      
      if !$scope.pusher.channel(channelName)?
        $scope.pusher_channel = $scope.pusher.subscribe channelName
      
        pusherEvent = (res) =>
          $scope.getQueuers()

        $scope.pusher_channel.bind 'notification', pusherEvent


  
    # this is used to retrigger a scope check that will update service time
  $interval(->
    if $scope.queuers
      for queuer in $scope.queuers
        queuer.remaining()
  , 5000)
