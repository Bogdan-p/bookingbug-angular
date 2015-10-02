'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbGetAvailability
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbGetAvailability
*
* See Controller {@link BB.Controllers:GetAvailability GetAvailability}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'GetAvailability'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbGetAvailability', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'GetAvailability'
  link : (scope, element, attrs) ->
    if attrs.bbGetAvailability
      scope.loadAvailability(scope.$eval( attrs.bbGetAvailability ) )
    return


###**
* @ngdoc controller
* @name BB.Controllers:GetAvailability
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller GetAvailability
*
* # Has the following set of methods:
*
* - $scope.loadAvailability(prms)
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {function} $element angular.element AWraps a raw DOM element or HTML string as a jQuery element.
* <br>
* {@link https://docs.angularjs.org/api/ng/function/angular.element more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} AdminTimeService Info
* <br>
* {@link BBAdmin.Services:AdminTimeService more}
*
* @param {service} AlertService Info
* <br>
* {@link BB.Services:AlertService more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} halClient Info
* <br>
* {@link angular-hal:halClient more}
*
* @param {service} $attrs Info
*
###
angular.module('BB.Controllers').controller 'GetAvailability',
($scope, $element, $attrs, $rootScope, $q, TimeService, AlertService, BBModel, halClient) ->


  $scope.loadAvailability = (prms) =>

    service = halClient.$get($scope.bb.api_url + '/api/v1/' + prms.company_id + '/services/' + prms.service )
    service.then (serv) =>
      $scope.earliest_day = null
      sday = moment()
      eday = moment().add(30, 'days')
      serv.$get('days', {date: sday.toISOString(), edate: eday.toISOString()}).then (res) ->
        for day in res.days
          if day.spaces > 0 && !$scope.earliest_day
            $scope.earliest_day = moment(day.date)
            if day.first
              $scope.earliest_day.add(day.first, "minutes")
