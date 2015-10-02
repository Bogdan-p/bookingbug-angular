'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbDurations
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbDurations
*
* See Controller {@link BB.Controllers:DurationList DurationList}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'DurationList'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbDurations', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'DurationList'

###**
* @ngdoc controller
* @name BB.Controllers:DurationList
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller DurationList
*
* # Has the following set of methods:
*
* - $scope.loadData()
* - $scope.selectDuration(dur, route)
* - $scope.durationChanged()
* - $scope.setReady()
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} PageControllerService Info
* <br>
* {@link BB.Services:PageControllerService more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $attrs Info
*
* @param {service} AlertService Info
* <br>
* {@link BB.Services:AlertService more}
*
###
angular.module('BB.Controllers').controller 'DurationList', ($scope,  $rootScope, PageControllerService, $q, $attrs, AlertService) ->
  $scope.controller = "public.controllers.DurationList"
  $scope.notLoaded $scope

  angular.extend(this, new PageControllerService($scope, $q))

  $rootScope.connection_started.then ->
    $scope.loadData()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.loadData = () =>
    id = $scope.bb.company_id
    service = $scope.bb.current_item.service
    if service && !$scope.durations
      $scope.durations =
        (for d in _.zip(service.durations, service.prices)
          {value: d[0], price: d[1]})

      initial_duration = $scope.$eval($attrs.bbInitialDuration)

      for duration in $scope.durations
        # does the current item already have a duration?
        if $scope.bb.current_item.duration && duration.value == $scope.bb.current_item.duration
          $scope.duration = duration
        else if initial_duration and initial_duration is duration.value
          $scope.duration = duration
          $scope.bb.current_item.setDuration(duration.value)

        if duration.value < 60
          duration.pretty = duration.value + " minutes"
        else if duration.value == 60
          duration.pretty = "1 hour"
        else
          duration.pretty = Math.floor(duration.value/60) + " hours"
          rem = duration.value % 60
          if rem != 0
            duration.pretty += " " + rem + " minutes"

      if $scope.durations.length == 1
        $scope.skipThisStep()
        $scope.selectDuration($scope.durations[0], $scope.nextRoute)

    $scope.setLoaded $scope


  $scope.selectDuration = (dur, route) =>
    if $scope.$parent.$has_page_control
      $scope.duration = dur
      return
    else
      $scope.bb.current_item.setDuration(dur.value)
      $scope.decideNextPage(route)
      return true

  $scope.durationChanged = () =>
    $scope.bb.current_item.setDuration($scope.duration.value)
    $scope.broadcastItemUpdate()


  $scope.setReady = () =>
    if $scope.duration
      $scope.bb.current_item.setDuration($scope.duration.value)
      return true
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select a duration" })
      return false


  # when the current item is updated, reload the duration data
  $scope.$on "currentItemUpdate", (event) ->
    $scope.loadData()
