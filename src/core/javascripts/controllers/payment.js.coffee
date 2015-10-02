'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbPayment
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbPayment
*
* See Controller {@link BB.Controllers:Payment Payment}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* controller: 'Payment'
* link: linker
* </pre>
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @param {service} $location The $location service parses the URL in the browser address bar
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$location more}
*
* @param {service} $sce $sce is a service that provides Strict Contextual Escaping services to AngularJS.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$sce more}
*
* @param {service} SettingsService Info
* <br>
* {@link BB.Services:SettingsService more}
*
###
angular.module('BB.Directives').directive 'bbPayment', ($window, $location, $sce, SettingsService) ->

  error = (scope, message) ->
    scope.error(message)

  getHost = (url) ->
    a = document.createElement('a')
    a.href = url
    a['protocol'] + '//' +a['host']

  sendLoadEvent = (element, origin, scope) ->
    referrer = $location.protocol() + "://" + $location.host()
    if $location.port()
      referrer += ":" + $location.port()
    custom_stylesheet = scope.payment_options.custom_stylesheet if scope.payment_options.custom_stylesheet
    payload = JSON.stringify({
      'type': 'load',
      'message': referrer,
      'custom_partial_url': scope.bb.custom_partial_url,
      'custom_stylesheet' : custom_stylesheet,
      'scroll_offset'     : SettingsService.getScrollOffset()
    })
    element.find('iframe')[0].contentWindow.postMessage(payload, origin)

  linker = (scope, element, attributes) ->

    scope.payment_options = scope.$eval(attributes.bbPayment) or {}

    element.find('iframe').bind 'load', (event) =>
      url = scope.bb.total.$href('new_payment')
      origin = getHost(url)
      sendLoadEvent(element, origin, scope)
      scope.$apply ->
        scope.callSetLoaded()

    $window.addEventListener 'message', (event) =>
      if angular.isObject(event.data)
        data = event.data
      else if not event.data.match(/iFrameSizer/)
        data = JSON.parse event.data
      scope.$apply =>
        if data
          switch data.type
            when "submitting"
              scope.callNotLoaded()
            when "error"
              scope.callSetLoaded()
              error(scope, event.data.message)
            when "payment_complete"
              scope.callSetLoaded()
              scope.paymentDone()
    , false

  return {
    restrict: 'AE'
    replace: true
    scope: true
    controller: 'Payment'
    link: linker
  }

###**
* @ngdoc controller
* @name BB.Controllers:Payment
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller Payment
*
* # Has the following set of methods:
*
* - $scope.callNotLoaded()
* - $scope.callSetLoaded()
* - $scope.paymentDone()
* - $scope.error(message)
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} $location The $location service parses the URL in the browser address bar
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$location more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @param {service} $sce $sce is a service that provides Strict Contextual Escaping services to AngularJS.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$sce more}
*
* @param {service} $log Simple service for logging.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$log more}
*
* @param {service} $timeout Angular's wrapper for window.setTimeout.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$timeout more}
*
###
angular.module('BB.Controllers').controller 'Payment', ($scope,  $rootScope, $q, $location, $window, $sce, $log, $timeout) ->

  $scope.controller = "public.controllers.Payment"

  $scope.notLoaded $scope

  $scope.bb.total = $scope.purchase if $scope.purchase

  $rootScope.connection_started.then =>
    $scope.bb.total = $scope.total if $scope.total
    $scope.url = $sce.trustAsResourceUrl($scope.bb.total.$href('new_payment'))

  $scope.callNotLoaded = () =>
    $scope.notLoaded $scope

  $scope.callSetLoaded = () =>
    $scope.setLoaded $scope

  $scope.paymentDone = () ->
    $scope.bb.payment_status = "complete"
    $scope.decideNextPage()

  $scope.error = (message) ->
    $log.warn("Payment Failure: " + message)
