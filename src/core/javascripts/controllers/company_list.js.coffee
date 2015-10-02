'use strict';

###**
* @ngdoc controller
* @name public.Controllers:CompanyList
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller CompanyList
*
* # Has the following set of methods:
*
* - $scope.init(comp)
* - $scope.selectItem(item, route)
* - $scope.splitString(company)
*
* @requires $scope
* @requires $rootScope
* @requires $q
* @requires $attrs
*
###

CompanyListBase = ($scope, $rootScope, $q, $attrs) ->

  $scope.controller = "public.controllers.CompanyList"
  $scope.notLoaded $scope

  options = $scope.$eval $attrs.bbCompanies

  $rootScope.connection_started.then =>
    if $scope.bb.company.companies
      $scope.init($scope.bb.company)
      $rootScope.parent_id = $scope.bb.company.id
    else if $rootScope.parent_id
      $scope.initWidget({company_id:$rootScope.parent_id, first_page: $scope.bb.current_page})
      return

    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.init = (comp) =>
    $scope.companies = $scope.bb.company.companies
    if !$scope.companies || $scope.companies.length == 0
      $scope.companies = [$scope.bb.company]

    if $scope.companies.length == 1
      $scope.selectItem($scope.companies[0])
    else
      if options and options.hide_not_live_stores
        $scope.items = $scope.companies.filter (c) -> c.live
      else
        $scope.items = $scope.companies
    $scope.setLoaded $scope

  $scope.selectItem = (item, route) =>
    $scope.notLoaded $scope
    prms = {company_id: item.id}
    $scope.initWidget(prms)

  # TODO move this into a mothercare js file
  $scope.splitString = (company) ->
    arr    = company.name.split(' ')
    result = if arr[2] then arr[2] else ""


###**
* @ngdoc directive
* @name BB.Directives:bbCompanies
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbCompanies
*
* See Controller {@link BB.Controllers:CompanyList CompanyList}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'CompanyList'
* </pre>
*
###

angular.module('BB.Directives').directive 'bbCompanies', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'CompanyList'

###**
* @ngdoc controller
* @name BB.Controllers:CompanyList
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller CompanyList
*
* # Has the following set of methods:
*
###

angular.module('BB.Controllers').controller 'CompanyList', CompanyListBase

###**
* @ngdoc directive
* @name BB.Directives:bbPostcodeLookup
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:CompanyList
*
* See Controller {@link BB.Controllers:PostcodeLookup PostcodeLookup}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'PostcodeLookup'
* </pre>
*
###

angular.module('BB.Directives').directive 'bbPostcodeLookup', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'PostcodeLookup'

###**
* @ngdoc controller
* @name BB.Controllers:PostcodeLookup
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller PostcodeLookup
*
* # Has the following set of methods:
*
* - $scope.getNearestCompany({center})
* - $scope.searchPostcode(form, prms)
*
* @param {object} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} ValidatorService Info
* <br>
* {@link BB.Services:ValidatorService more}
*
* @param {service} AlertService Info
* <br>
* {@link BB.Services:AlertService more}
*
* @param {service} $attrs Info
*
###

angular.module('BB.Controllers').controller 'PostcodeLookup', ($scope,  $rootScope, $q, ValidatorService, AlertService, $attrs) ->
  $scope.controller = "PostcodeLookup"
  angular.extend(this, new CompanyListBase($scope, $rootScope, $q, $attrs))


  $scope.validator = ValidatorService


  $scope.searchPostcode = (form, prms) =>

    $scope.notLoaded($scope)

    promise = ValidatorService.validatePostcode(form, prms)
    if promise
      promise.then () ->
        $scope.bb.postcode = ValidatorService.getGeocodeResult().address_components[0].short_name
        $scope.postcode = $scope.bb.postcode
        loc = ValidatorService.getGeocodeResult().geometry.location
        $scope.selectItem($scope.getNearestCompany({center: loc}))
      ,(err) ->
        $scope.setLoaded($scope)
    else
      $scope.setLoaded($scope)


  $scope.getNearestCompany = ({center}) =>

    pi = Math.PI;
    R = 6371  #equatorial radius
    distances = []

    lat1 = center.lat();
    lon1 = center.lng();

    for company in $scope.items
      if company.address.lat && company.address.long && company.live
        latlong = new google.maps.LatLng(company.address.lat,company.address.long)

        lat2 = latlong.lat()
        lon2 = latlong.lng()

        chLat = lat2-lat1;
        chLon = lon2-lon1;

        dLat = chLat*(pi/180);
        dLon = chLon*(pi/180);

        rLat1 = lat1*(pi/180);
        rLat2 = lat2*(pi/180);

        a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(rLat1) * Math.cos(rLat2);
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        d = R * c;

        company.distance = d
        distances.push company

      distances.sort (a,b)=>
        a.distance - b.distance

    return distances[0]

