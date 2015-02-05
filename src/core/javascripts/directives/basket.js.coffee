'use strict';

#
# Basket Directive
# Example usage;
# <div bb-basket></div>
# <div bb-basket mini></div>
#
angular.module('BB.Directives').directive 'bbBasket', (PathSvc) ->
  restrict: 'A'
  replace: true
  scope : true
  templateUrl : (element, attrs) ->
    if _.has attrs, 'mini'
    then PathSvc.directivePartial "basket_mini"
    else PathSvc.directivePartial "basket"
  controllerAs : 'BasketCtrl'

  controller : ($scope) ->
    $scope.setUsingBasket true

    this.empty = () ->
      $scope.$eval('emptyBasket()')

    this.view = ->
      $scope.$eval('viewBasket()')

    $scope.$watch ->
      $scope.basketItemCount = len = if $scope.bb.basket then $scope.bb.basket.length() else 0
      if not len
        $scope.basketStatus = "empty"
      else
        if len is 1
          $scope.basketStatus = "1 item in your basket"
        else
          $scope.basketStatus = len + " items in your basket"
      return
    return

  link : (scope, element, attrs) ->
    # stop the default action of links inside directive. you can pass the $event
    # object in from the view to the function bound to ng-click but this keeps
    # the markup tidier
    element.bind 'click', (e) ->
      e.preventDefault()


angular.module('BB.Directives').directive 'bbMinSpend', () ->
  restrict: 'A'
  scope: true
  controller: ($scope, $element, $attrs, AlertService) ->

    options = $scope.$eval $attrs.bbMinSpend or {}
    $scope.min_spend = options.min_spend or 0
    #$scope.items = options.items or {}

    $scope.setReady = () ->
      return checkMinSpend()

    checkMinSpend = () ->
      price = 0
      for item in $scope.bb.stacked_items
        price += (item.service.price * 100)

      if price >= $scope.min_spend
        AlertService.clear()
        return true
      else
        AlertService.clear()
        AlertService.add("danger", { msg: "You need to spend at least �#{$scope.min_spend/100} to make a booking." })
        return false
