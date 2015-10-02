'use strict';

# Directives
app = angular.module 'BB.Directives'

###**
* @ngdoc directive
* @name BB.Directives:bbContentNew
* @restrict A
* @scope true;
*
* @description
* Directive BB.Directives:bbContentNew
*
* <pre>
* restrict: 'A'
* replace: true
* scope : true
* templateUrl : PathSvc.directivePartial "content_main"
* </pre>
* # Has the following set of methods:
*
* - controller($scope)
*
* @param {service} PathSvc Info
* <br>
* {@link BB.Services:PathSvc more}
*
###
app.directive 'bbContentNew', (PathSvc) ->
  restrict: 'A'
  replace: true
  scope : true
  templateUrl : PathSvc.directivePartial "content_main"
  controller : ($scope)->
    $scope.initPage = ->
      $scope.$eval('setPageLoaded()')
    return
