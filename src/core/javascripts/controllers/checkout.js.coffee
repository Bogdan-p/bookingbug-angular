'use strict';


angular.module('BB.Directives').directive 'bbCheckout', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Checkout'


###**
* @ngdoc controller
* @name BB.Controllers:Checkout
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller Checkout
*
* # Has the following set of methods:
*
* - $scope.print()
* - $scope.printElement(id, stylesheet)
* -
*
* @param {object} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {service} $attrs Info
*
* @param {service} BasketService Info
* <br>
* {@link BB.Services:BasketService more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $location The $location service parses the URL in the browser address bar
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$location more}
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @param {model} $bbug Releases the hold on the $ shortcut identifier, so that other scripts can use it.
* <br>
* {@link $bbug more}
*
* @param {service} FormDataStoreService Info
* <br>
* {@link BB.Services:FormDataStoreService more}
*
* @param {service} $timeout Angular's wrapper for window.setTimeout.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$timeout more}
*
###
angular.module('BB.Controllers').controller 'Checkout', ($scope, $rootScope, $attrs, BasketService, $q, $location, $window, $bbug, FormDataStoreService, $timeout) ->
  $scope.controller = "public.controllers.Checkout"
  $scope.notLoaded $scope

  $scope.options = $scope.$eval($attrs.bbCheckout) or {}

  # clear the form data store as we no longer need the data
  FormDataStoreService.destroy($scope)

  $rootScope.connection_started.then =>
    $scope.bb.basket.setClient($scope.client)
    $scope.loadingTotal = BasketService.checkout($scope.bb.company, $scope.bb.basket, {bb: $scope.bb})
    $scope.loadingTotal.then (total) =>
      $scope.total = total

      # if no payment is required, route to the next step unless instructed otherwise
      if !total.$has('new_payment')
        $scope.$emit("checkout:success", total)
        $scope.bb.total = $scope.total
        $scope.bb.payment_status = 'complete'
        if !$scope.options.disable_confirmation
          $scope.skipThisStep()
          $scope.decideNextPage()

      $scope.checkoutSuccess = true
      $scope.setLoaded $scope
      # currently just close the window and refresh the parent if we're in an admin popup
    , (err) ->
      $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
      $scope.checkoutFailed = true
      $scope.$emit("checkout:fail", err)

  , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  # Deprecated - use window.print or $scope.printElement
  # Print booking details using print_purchase.html template
  $scope.print = () =>
    $window.open($scope.bb.partial_url+'print_purchase.html?id='+$scope.total.long_id,'_blank',
                'width=700,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0')
    return true


  # Print by creating popup containing the contents of the specified element
  # TODO move print methods to a service
  $scope.printElement = (id, stylesheet) ->
    data = $bbug('#'+ id).html()
    # window.open(URL,name,specs,replace)
    # IE8 fix: URL and name params are deliberately left as blank
    # http://stackoverflow.com/questions/710756/ie8-var-w-window-open-message-invalid-argument
    mywindow = $window.open('', '', 'height=600,width=800')

    $timeout () ->
      mywindow.document.write '<html><head><title>Booking Confirmation</title>'

      mywindow.document.write('<link rel="stylesheet" href="' + stylesheet + '" type="text/css" />') if stylesheet
      mywindow.document.write '</head><body>'
      mywindow.document.write data
      mywindow.document.write '</body></html>'
      #mywindow.document.close()

      $timeout () ->
        mywindow.document.close()
        # necessary for IE >= 10
        mywindow.focus()
        # necessary for IE >= 10
        mywindow.print()
        mywindow.close()
      , 100
    , 2000
