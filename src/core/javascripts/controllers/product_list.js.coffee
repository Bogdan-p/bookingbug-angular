'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbProductList
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbProductList
*
* See Controller {@link BB.Controllers:ProductList ProductList}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* controller: 'ProductList'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbProductList', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'ProductList'
  link : (scope, element, attrs) ->
    if attrs.bbItem
      scope.booking_item = scope.$eval( attrs.bbItem )
    if attrs.bbShowAll
      scope.show_all = true
    return

###**
* @ngdoc controller
* @name BB.Controllers:ProductList
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller ProductList
*
* # Has the following set of methods:
*
* - $scope.init(company)
* - $scope.selectItem(item, route)
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
* @param {service} $attrs Info
*
* @param {service} ItemService Info
* <br>
* {@link BB.Services:ItemService more}
*
* @param {service} FormDataStoreService Info
* <br>
* {@link BB.Services:FormDataStoreService more}
*
* @param {service} ValidatorService Info
* <br>
* {@link BB.Services:ValidatorService more}
*
* @param {service} PageControllerService Info
* <br>
* {@link BB.Services:PageControllerService more}
*
* @param {model} halClient Info
* <br>
* {@link angular-hal:halClient more}
*
###
angular.module('BB.Controllers').controller 'ProductList', ($scope,
    $rootScope, $q, $attrs, ItemService, FormDataStoreService, ValidatorService,
    PageControllerService, halClient) ->

  $scope.controller = "public.controllers.ProductList"

  $scope.notLoaded $scope

  $scope.validator = ValidatorService

  $rootScope.connection_started.then ->
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->
    $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.init = (company) ->
    $scope.booking_item ||= $scope.bb.current_item

    company.$get('products').then (products) ->
      products.$get('products').then (products) ->
        $scope.products = products
        $scope.setLoaded $scope

  $scope.selectItem = (item, route) ->
    if $scope.$parent.$has_page_control
      $scope.product = item
      false
    else
      $scope.booking_item.setProduct(item)
      $scope.decideNextPage(route)
      true

