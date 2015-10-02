'use strict';


# TODO: Try and get all the baset logic into a service. The basket list
# doesn't look like it's used anywhere.

###**
* @ngdoc directive
* @name BB.Directives:bbMiniBasket
* @restrict AE
* @scope true
*
* @description
* Directive BB.Directives:bbMiniBasket
*
* See Controller {@link BB.Controllers:MiniBasket MiniBasket}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'MiniBasket'
* </pre>
*
*
###
angular.module('BB.Directives').directive 'bbMiniBasket', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'MiniBasket'

###**
* @ngdoc controller
* @name BB.Controllers:MiniBasket
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller MiniBasket
*
* # Has the following set of methods:
* - $scope.basketDescribe(nothing, single, plural)
*
* @requires $scope
* @requires $q
* @requires $rootScope
* @requires BB.Services:BasketService
*
###
angular.module('BB.Controllers').controller 'MiniBasket', ($scope,  $rootScope, BasketService, $q) ->
  $scope.controller = "public.controllers.MiniBasket"
  $scope.setUsingBasket(true)
  $rootScope.connection_started.then () =>

  $scope.basketDescribe = (nothing, single, plural) =>
    if !$scope.bb.basket || $scope.bb.basket.length() == 0
      nothing
    else if $scope.bb.basket.length() == 1
      single
    else
      plural.replace("$0", $scope.bb.basket.length())





angular.module('BB.Directives').directive 'bbBasketList', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'BasketList'


###**
* @ngdoc controller
* @name BB.Controllers:BasketList
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller BasketList
*
* # Has the following set of methods:
*
* - $scope.addAnother(route)
* - $scope.checkout (route)
* - $scope.applyCoupon(coupon)
* - $scope.applyDeal(deal_code)
* - $scope.removeDeal(deal_code)
* - $scope.setReady
*
* @param {object} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {service} BasketService Info
* <br>
* {@link BB.Services:BasketService more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} AlertService Info
* <br>
* {@link BB.Services:AlertService more}
*
* @param {service} ErrorService Info
* <br>
* {@link BB.Services:ErrorService more}
*
* @param {service} FormDataStoreService Info
* <br>
* {@link BB.Services:FormDataStoreService more}
*
###
angular.module('BB.Controllers').controller 'BasketList', ($scope,  $rootScope, BasketService, $q, AlertService, ErrorService, FormDataStoreService) ->
  $scope.controller = "public.controllers.BasketList"
  $scope.setUsingBasket(true)
  $scope.items = $scope.bb.basket.items


  $scope.$watch 'basket', (newVal, oldVal) =>
    $scope.items = _.filter $scope.bb.basket.items, (item) -> !item.is_coupon


  $scope.addAnother = (route) =>
    $scope.clearBasketItem()
    $scope.bb.emptyStackedItems()
    $scope.bb.current_item.setCompany($scope.bb.company)
    $scope.restart()


  $scope.checkout = (route) =>
    # Reset the basket to the last item whereas the curren_item is not complete and should not be in the basket and that way, we can proceed to checkout instead of hard-coding it on the html page.
    $scope.setReadyToCheckout(true)
    if $scope.bb.basket.items.length > 0
      $scope.decideNextPage(route)
    else
      AlertService.clear()
      AlertService.add('info',ErrorService.getError('EMPTY_BASKET_FOR_CHECKOUT'))
      return false


  $scope.applyCoupon = (coupon) =>
    AlertService.clear()
    $scope.notLoaded $scope
    params = {bb: $scope.bb, coupon: coupon }
    BasketService.applyCoupon($scope.bb.company, params).then (basket) ->
      for item in basket.items
        item.storeDefaults($scope.bb.item_defaults)
        item.reserve_without_questions = $scope.bb.reserve_without_questions
      basket.setSettings($scope.bb.basket.settings)
      $scope.setBasket(basket)
      $scope.setLoaded $scope
    , (err) ->
      if err && err.data && err.data.error
        AlertService.clear()
        AlertService.add("danger", { msg: err.data.error })
      $scope.setLoaded $scope

  $scope.applyDeal = (deal_code) =>
    AlertService.clear()
    if $scope.client
      params = {bb: $scope.bb, deal_code: deal_code, member_id: $scope.client.id}
    else
      params = {bb: $scope.bb, deal_code: deal_code, member_id: null}
    BasketService.applyDeal($scope.bb.company, params).then (basket) ->

      for item in basket.items
        item.storeDefaults($scope.bb.item_defaults)
        item.reserve_without_questions = $scope.bb.reserve_without_questions
      basket.setSettings($scope.bb.basket.settings)
      $scope.setBasket(basket)
      $scope.items = $scope.bb.basket.items
      $scope.deal_code = null
    , (err) ->
      if err && err.data && err.data.error
        AlertService.clear()
        AlertService.add("danger", { msg: err.data.error })

  $scope.removeDeal = (deal_code) =>
    params = {bb: $scope.bb, deal_code_id: deal_code.id }
    BasketService.removeDeal($scope.bb.company, params).then (basket) ->

      for item in basket.items
        item.storeDefaults($scope.bb.item_defaults)
        item.reserve_without_questions = $scope.bb.reserve_without_questions
      basket.setSettings($scope.bb.basket.settings)
      $scope.setBasket(basket)
      $scope.items = $scope.bb.basket.items
    , (err) ->
      if err && err.data && err.data.error
        AlertService.clear()
        AlertService.add("danger", { msg: err.data.error })


  $scope.setReady = ->
    if $scope.bb.basket.items.length > 0
      $scope.setReadyToCheckout(true)
    else
      AlertService.add 'info', ErrorService.getError('EMPTY_BASKET_FOR_CHECKOUT')

