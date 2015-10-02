'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbPurchaseTotal
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbPurchaseTotal
*
* See Controller {@link BB.Controllers:PurchaseTotal PurchaseTotal}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* controller: 'PurchaseTotal'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbPurchaseTotal', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'PurchaseTotal'

###**
* @ngdoc controller
* @name BB.Controllers:PurchaseTotal
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller PurchaseTotal
*
* # Has the following set of methods:
*
* - $scope.load(total_id)
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @param {service} PurchaseTotalService Info
* <br>
* {@link BB.Services:PurchaseTotalService more}
*
###
angular.module('BB.Controllers').controller 'PurchaseTotal',
($scope, $rootScope, $window, PurchaseTotalService, $q) ->
  $scope.controller = "public.controllers.PurchaseTotal"

  angular.extend(this, new $window.PageController($scope, $q))

  $scope.load = (total_id) =>
    $rootScope.connection_started.then =>
      $scope.loadingTotal = PurchaseTotalService.query({company: $scope.bb.company, total_id: total_id})
      $scope.loadingTotal.then (total) =>
        $scope.total = total

