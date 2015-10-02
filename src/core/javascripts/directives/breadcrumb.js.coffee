'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbBreadcrumb
* @restrict A
* @scope true
*
* @description
* Directive BB.Directives:bbBreadcrumb
*
* <pre>
* restrict: 'A'
* replace: true
* scope : true
* controller : 'Breadcrumbs'
* </pre>
* # Has the following set of methods:
*
* - templateUrl(element, attrs)
* - link(scope)
*
* @param {service} PathSvc Info
* <br>
* {@link BB.Services:PathSvc more}
*
###
angular.module('BB.Directives').directive 'bbBreadcrumb', (PathSvc) ->
  restrict: 'A'
  replace: true
  scope : true
  controller : 'Breadcrumbs'
  templateUrl : (element, attrs) ->
    if _.has attrs, 'complex'
    then PathSvc.directivePartial "_breadcrumb_complex"
    else PathSvc.directivePartial "_breadcrumb"

  link : (scope) ->
    return

###**
* @ngdoc directive
* @name BB.Controllers:Breadcrumbs
* @restrict A
* @scope true
*
* @description
* Directive Breadcrumbs
* <br>
* Used to load the application's content. It uses ng-include.
*
* <pre>
* loadStep        = $scope.loadStep
* $scope.steps    = $scope.bb.steps
* $scope.allSteps = $scope.bb.allSteps
* </pre>
* # Has the following set of methods:
*
* - $scope.loadStep(number)
* - lastStep()
* - currentStep(step)
* - atDisablePoint()
* - $scope.isDisabledStep(step)
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
###
angular.module('BB.Controllers').controller 'Breadcrumbs', ($scope) ->
  loadStep        = $scope.loadStep
  $scope.steps    = $scope.bb.steps
  $scope.allSteps = $scope.bb.allSteps

  # stop users from clicking back once the form is completed ###
  $scope.loadStep = (number) ->
    if !lastStep() && !currentStep(number) && !atDisablePoint()
      loadStep number


  lastStep = () ->
    return $scope.bb.current_step is $scope.bb.allSteps.length


  currentStep = (step) ->
    return step is $scope.bb.current_step


  atDisablePoint = () ->
    return false if !angular.isDefined($scope.bb.disableGoingBackAtStep)
    return $scope.bb.current_step >= $scope.bb.disableGoingBackAtStep


  $scope.isDisabledStep = (step) ->
    if lastStep() or currentStep(step.number) or !step.passed or atDisablePoint()
      return true
    else
      return false
