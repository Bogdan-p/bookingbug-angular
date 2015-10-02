'use strict';

# Directives
app = angular.module 'BB.Directives'

###**
* @ngdoc directive
* @name BB.Directives:bbPaypal
* @restrict A
* @replace true
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BB.Directives:bbPaypal
*
* <pre>
* restrict: 'A'
* replace: true
* scope : {
*   ppDetails : "=bbPaypal"
* }
* templateUrl : PathSvc.directivePartial "paypal_button"
* </pre>
*
* Has the following set of methods:
* - link(scope, element, attrs)
*
* @param {service} PathSvc Info
* <br>
* {@link BB.Services:PathSvc more}
*
###
app.directive 'bbPaypal', (PathSvc) ->
  restrict: 'A'
  replace: true
  scope : {
    ppDetails : "=bbPaypal"
  }
  templateUrl : PathSvc.directivePartial "paypal_button"
  link : (scope, element, attrs) ->
    scope.inputs = []

    if !scope.ppDetails
      return

    keys = _.keys scope.ppDetails
    #  convert the paypal data to an array of input objects
    _.each keys, (keyName) ->
      obj = {
        name : keyName
        value : scope.ppDetails[keyName]
      }
      scope.inputs.push obj




