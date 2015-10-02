'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbDeals
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbDeals
*
* See Controller {@link BB.Controllers:DealList DealList}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'DealList'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbDeals', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'DealList'

###**
* @ngdoc controller
* @name BB.Controllers:DealList
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller DealList
*
* # Has the following set of methods:
*
* - init()
* - $scope.selectDeal(deal)
* - ModalInstanceCtrl($scope, $modalInstance, item, ValidatorService)
* - $scope.addToBasket(form)
* - $scope.cancel
* - $scope.purchaseDeals
* - $scope.setReady
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} DealService Info
* <br>
* {@link BB.Services:DealService more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {service} AlertService Info
* <br>
* {@link BB.Services:AlertService more}
*
* @param {service} FormDataStoreService Info
* <br>
* {@link BB.Services:FormDataStoreService more}
*
* @param {service} ValidatorService Info
* <br>
* {@link BB.Services:ValidatorService more}
*
* @param {service} $modal is a service to quickly create AngularJS-powered modal windows. Creating custom modals is straightforward: create a partial view, its controller and reference them when using the service.
* <br>
* {@link https://github.com/angular-ui/bootstrap/tree/master/src/modal/docs more}
*
###
angular.module('BB.Controllers').controller 'DealList', ($scope, $rootScope, DealService, $q, BBModel, AlertService, FormDataStoreService, ValidatorService, $modal) ->

  $scope.controller = "public.controllers.DealList"
  FormDataStoreService.init 'TimeRangeList', $scope, [ 'deals' ]

  $rootScope.connection_started.then ->
    init()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  init = () ->
    $scope.notLoaded $scope
    if !$scope.deals
      deal_promise = DealService.query($scope.bb.company)
      deal_promise.then (deals) ->
        $scope.deals = deals
        $scope.setLoaded $scope


  $scope.selectDeal = (deal) ->
    iitem = new (BBModel.BasketItem)(null, $scope.bb)
    iitem.setDefaults $scope.bb.item_defaults
    iitem.setDeal deal
    if !$scope.bb.company_settings.no_recipient
      modalInstance = $modal.open
        templateUrl: $scope.getPartial('_add_recipient')
        scope: $scope
        controller: ModalInstanceCtrl
        resolve:
          item: ->
            iitem

      modalInstance.result.then (item) ->
        $scope.notLoaded $scope
        $scope.setBasketItem item
        $scope.addItemToBasket().then ->
          $scope.setLoaded $scope
        , (err) ->
          $scope.setLoadedAndShowError $scope, err, 'Sorry, something went wrong'
    else
      $scope.notLoaded $scope
      $scope.setBasketItem iitem
      $scope.addItemToBasket().then ->
        $scope.setLoaded $scope
      , (err) ->
        $scope.setLoadedAndShowError $scope, err, 'Sorry, something went wrong'

  ModalInstanceCtrl = ($scope, $modalInstance, item, ValidatorService) ->
    $scope.controller = 'ModalInstanceCtrl'
    $scope.item = item
    $scope.recipient = false

    $scope.addToBasket = (form) ->
      if !ValidatorService.validateForm(form)
        return
      $modalInstance.close($scope.item)

    $scope.cancel = ->
      $modalInstance.dismiss 'cancel'

  $scope.purchaseDeals = ->
    if $scope.bb.basket.items and $scope.bb.basket.items.length > 0
      $scope.decideNextPage()
    else
      AlertService.add('danger', msg: 'You need to select at least one Gift Certificate to continue')

  $scope.setReady = ->
    if $scope.bb.basket.items and $scope.bb.basket.items.length > 0
      true
    else
      AlertService.add('danger', msg: 'You need to select at least one Gift Certificate to continue')
