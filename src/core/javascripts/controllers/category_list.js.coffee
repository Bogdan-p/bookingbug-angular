'use strict';

angular.module('BB.Directives').directive 'bbCategories', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CategoryList'

###**
* @ngdoc controller
* @name BB.Controllers:CategoryList
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller CategoryList
*
* # Has the following set of methods:
* - method1
*
* @param {object} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {service} CategoryService Info
* <br>
* {@link BB.Services:CategoryService more}
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
angular.module('BB.Controllers').controller 'CategoryList',
($scope,  $rootScope, CategoryService, $q, PageControllerService) ->
  $scope.controller = "public.controllers.CategoryList"
  $scope.notLoaded $scope

  angular.extend(this, new PageControllerService($scope, $q))

  $rootScope.connection_started.then =>
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.init = (comp) =>
    CategoryService.query(comp).then (items) =>
      $scope.items = items
      if (items.length == 1)
        $scope.skipThisStep()
        $rootScope.categories = items
        $scope.selectItem(items[0], $scope.nextRoute )
      $scope.setLoaded $scope
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.selectItem = (item, route) =>
    $scope.bb.current_item.setCategory(item)
    $scope.decideNextPage(route)

