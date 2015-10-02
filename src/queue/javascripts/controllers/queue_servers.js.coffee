###**
* @ngdoc controller
* @name BBQueue.Controllers:bbQueueServers
*
* @description
*{@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller bbQueueServers
*
* # Has the following set of methods:
*
* - $scope.getServers()
* - $scope.setAttendance(person, status)
* - $scope.updateQueuers()
* - $scope.startServingQueuer(person, queuer)
* - $scope.finishServingQueuer(person)
* - $scope.dropCallback(event, ui, queuer, $index)
* - $scope.dragStart(event, ui, queuer)
* - $scope.dragStop(event, ui)
*
* @requires $scope
* @requires $log
* @requires BBQueue.Services:AdminQueueService
* @requires BB.Services:ModalForm
* @requires BBAdmin.Services:AdminPersonService
*
###

angular.module('BBQueue').controller 'bbQueueServers', ($scope, $log,
    AdminQueueService, ModalForm, AdminPersonService) ->

  $scope.loading = true

  ###**
  * @ngdoc method
  * @name $scope.getServers
  * @methodOf BBQueue.Controllers:bbQueueServers
  * @description
  * 
  ###  

  $scope.getServers = () ->
    AdminPersonService.query({company: $scope.company}).then (people) ->
      $scope.all_people = people
      $scope.servers = []
      for person in $scope.all_people
        $scope.servers.push(person) if !person.queuing_disabled
      $scope.loading = false
      $scope.updateQueuers()
    , (err) ->
      $log.error err.data
      $scope.loading = false

  ###**
  * @ngdoc method
  * @name $scope.setAttendance
  * @methodOf BBQueue.Controllers:bbQueueServers
  * @description
  * 
  ###  
 
  $scope.setAttendance = (person, status) ->
    $scope.loading = true
    person.setAttendance(status).then (person) ->
      $scope.loading = false
    , (err) ->
      $log.error err.data
      $scope.loading = false

  # update all servers to make sure each one is shows as serving the right person
  $scope.$watch 'queuers', (newValue, oldValue) =>
    $scope.updateQueuers()

  ###**
  * @ngdoc method
  * @name $scope.updateQueuers
  * @methodOf BBQueue.Controllers:bbQueueServers
  * @description
  * 
  ###  

  $scope.updateQueuers = () ->
    if $scope.queuers && $scope.servers
      shash = {}
      for server in $scope.servers
        server.serving = null
        shash[server.self] = server
      for queuer in $scope.queuers
        if queuer.$href('person') && shash[queuer.$href('person')] && queuer.position == 0 
          # currently being seen
          shash[queuer.$href('person')].serving = queuer

  ###**
  * @ngdoc method
  * @name $scope.startServingQueuer
  * @methodOf BBQueue.Controllers:bbQueueServers
  * @description
  * 
  ### 

  $scope.startServingQueuer = (person, queuer) ->
    queuer.startServing(person).then () ->
      $scope.getQueuers()

  ###**
  * @ngdoc method
  * @name $scope.finishServingQueuer
  * @methodOf BBQueue.Controllers:bbQueueServers
  * @description
  * 
  ### 

  $scope.finishServingQueuer = (person) ->
    person.finishServing()
    $scope.getQueuers()

  ###**
  * @ngdoc method
  * @name $scope.dropCallback
  * @methodOf BBQueue.Controllers:bbQueueServers
  * @description
  * 
  ### 

  $scope.dropCallback = (event, ui, queuer, $index) ->
    console.log "dropcall"
    $scope.$apply () ->
      $scope.selectQueuer(null)
    return false

  ###**
  * @ngdoc method
  * @name $scope.dragStart
  * @methodOf BBQueue.Controllers:bbQueueServers
  * @description
  * 
  ### 

  $scope.dragStart = (event, ui, queuer) ->
    $scope.$apply () ->
      $scope.selectDragQueuer(queuer)
      $scope.selectQueuer(queuer)
    console.log "start", queuer  
    return false

  ###**
  * @ngdoc method
  * @name $scope.dragStop
  * @methodOf BBQueue.Controllers:bbQueueServers
  * @description
  * 
  ### 

  $scope.dragStop = (event, ui) ->
    console.log "stop", event, ui
    $scope.$apply () ->
      $scope.selectQueuer(null)
    return false
