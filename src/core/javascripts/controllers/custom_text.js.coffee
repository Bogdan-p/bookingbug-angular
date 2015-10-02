'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbCustomBookingText
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbCustomBookingText
*
* See Controller {@link BB.Controllers:CustomBookingText CustomBookingText}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'CustomBookingText'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbCustomBookingText', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CustomBookingText'

###**
* @ngdoc controller
* @name BB.Controllers:CustomBookingText
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller CustomBookingText
*
* # Has the following set of methods:
* - method1
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} CustomTextService Info
* <br>
* {@link BB.Services:CustomTextService more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
###
angular.module('BB.Controllers').controller 'CustomBookingText', ($scope,  $rootScope, CustomTextService, $q) ->
  $scope.controller = "public.controllers.CustomBookingText"
  $scope.notLoaded $scope

  $rootScope.connection_started.then =>
    CustomTextService.BookingText($scope.bb.company, $scope.bb.current_item).then (msgs) =>
      $scope.messages = msgs
      $scope.setLoaded $scope
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


###**
* @ngdoc directive
* @name BB.Directives:bbCustomConfirmationText
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbCustomConfirmationText
*
* See Controller {@link BB.Controllers:CustomConfirmationText CustomConfirmationText}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'CustomConfirmationText'
* </pre>
###
angular.module('BB.Directives').directive 'bbCustomConfirmationText', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CustomConfirmationText'

###**
* @ngdoc controller
* @name BB.Controllers:CustomConfirmationText
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller CustomConfirmationText
*
* # Has the following set of methods:
*
* - $scope.loadData()
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} CustomTextService Info
* <br>
* {@link BB.Services:CustomTextService more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} PageControllerService Info
* <br>
* {@link BB.Services:PageControllerService more}
*
###
angular.module('BB.Controllers').controller 'CustomConfirmationText', ($scope, $rootScope, CustomTextService, $q, PageControllerService) ->
  $scope.controller = "public.controllers.CustomConfirmationText"
  $scope.notLoaded $scope

  $rootScope.connection_started.then ->
    $scope.loadData()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.loadData = () =>

    if $scope.total

      CustomTextService.confirmationText($scope.bb.company, $scope.total).then (msgs) ->
        $scope.messages = msgs
        $scope.setLoaded $scope
      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

    else if $scope.loadingTotal

      $scope.loadingTotal.then (total) ->
        CustomTextService.confirmationText($scope.bb.company, total).then (msgs) ->
          $scope.messages = msgs
          $scope.setLoaded $scope
        , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

    else
      $scope.setLoaded $scope

