###**
* @ndgoc directive
* @name BBAdminBooking.Directives:bbAdminBookingClients
*
* @restrict AE
* @scope true
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBAdminBooking.Directives:bbAdminBookingClients
*
###

'use strict';

angular.module('BBAdminBooking').directive 'bbAdminBookingClients', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'adminBookingClients'

###**
* @ngdoc controller
* @name BBAdminBooking.Controllers:adminBookingClients
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller adminBookingClients
*
* # Has the following set of methods:
*
* - $scope.showSearch()
* - $scope.showClientForm()
* - $scope.selectClient(client, route)
* - $scope.checkSearch(search)
* - $scope.createClient(route)
* - $scope.getClients(currentPage, filterBy, filterByFields, orderBy, orderByReverse)
* - $scope.edit(item)
*
* @requires $scope
* @requires $rootScope
* @requires $q
* @requires BBAdmin.Services:AdminClientService
* @requires BB.Services:ClientDetailsService
* @requires BB.Services:AlertService
* @requires BB.Services:ClientService
* @requires BB.Services:ValidatorService
*
###

angular.module('BBAdminBooking').controller 'adminBookingClients', ($scope,  $rootScope, $q, AdminClientService, ClientDetailsService, AlertService, ClientService, ValidatorService) ->
  
  $scope.validator = ValidatorService
  $scope.clientDef = $q.defer()
  $scope.clientPromise = $scope.clientDef.promise 
  $scope.per_page = 20
  $scope.total_entries = 0
  $scope.clients = []
  $scope.searchClients = false
  $scope.newClient = false
  $scope.no_clients = false
  $scope.search_error = false


  ###**
  * @ngdoc method
  * @name $scope.showSearch
  * @methodOf BBAdminBooking.Controllers:adminBookingClients
  *
  * @description
  * Method $scope.showSearch
  *
  ###

  $scope.showSearch = () =>
    $scope.searchClients = true
    $scope.newClient = false
  
  ###**
  * @ngdoc method
  * @name $scope.showClientForm
  * @methodOf BBAdminBooking.Controllers:adminBookingClients
  *
  * @description
  * Method $scope.showClientForm
  *
  ###

  $scope.showClientForm = () =>
    $scope.search_error = false
    $scope.no_clients = false
    $scope.searchClients = false
    $scope.newClient = true
    # clear the client if one has already been selected
    $scope.clearClient()
  
  ###**
  * @ngdoc method
  * @name $scope.selectClient
  * @methodOf BBAdminBooking.Controllers:adminBookingClients
  *
  * @description
  * Method $scope.selectClient
  *
  * @param {object} client client
  * @param {object} client client
  *
  ###

  $scope.selectClient = (client, route) =>
    $scope.search_error = false
    $scope.no_clients = false
    $scope.setClient(client)
    $scope.client.setValid(true)
    $scope.decideNextPage(route)

  ###**
  * @ngdoc method
  * @name $scope.checkSearch
  * @methodOf BBAdminBooking.Controllers:adminBookingClients
  *
  * @description
  * Method $scope.checkSearch
  *
  * @param {object} search search
  * 
  * @returns {object} true or false
  ###

  $scope.checkSearch = (search) =>
    if search.length >= 3
      $scope.search_error = false
      return true
    else
      $scope.search_error = true
      return false

  ###**
  * @ngdoc method
  * @name $scope.createClient
  * @methodOf BBAdminBooking.Controllers:adminBookingClients
  *
  * @description
  * Method $scope.createClient
  *
  * @param {object} route route
  * 
  ###

  $scope.createClient = (route) =>
    $scope.notLoaded $scope

    # we need to validate the client information has been correctly entered here
    if $scope.bb && $scope.bb.parent_client
      $scope.client.parent_client_id = $scope.bb.parent_client.id
    $scope.client.setClientDetails($scope.client_details) if $scope.client_details

    ClientService.create_or_update($scope.bb.company, $scope.client).then (client) =>
      $scope.setLoaded $scope
      $scope.selectClient(client, route)
    , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
   
  ###**
  * @ngdoc method
  * @name $scope.getClients
  * @methodOf BBAdminBooking.Controllers:adminBookingClients
  *
  * @description
  * Method $scope.getClients
  *
  * @param {object} currentPage currentPage
  * @param {object} filterBy filterBy
  * @param {object} filterByFields filterByFields
  * @param {object} orderBy orderBy
  * @param {object} orderByReverse orderByReverse
  *
  * @returns {object} clientDef.reject(err)
  *
  ###

  $scope.getClients = (currentPage, filterBy, filterByFields, orderBy, orderByReverse) ->
    AlertService.clear()
    $scope.no_clients = false
    $scope.search_error = false
    clientDef = $q.defer()
    params = {company: $scope.bb.company, per_page: $scope.per_page, filter_by: filterBy, filter_by_fields: filterByFields, order_by: orderBy, order_by_reverse: orderByReverse}
    params.page = currentPage+1 if currentPage
    $rootScope.connection_started.then ->
      $scope.notLoaded $scope
      $rootScope.bb.api_url = $scope.bb.api_url if !$rootScope.bb.api_url && $scope.bb.api_url
      AdminClientService.query(params).then (clients) =>
        $scope.clients = clients.items
        $scope.setLoaded $scope
        $scope.setPageLoaded()
        $scope.total_entries = clients.total_entries
        clientDef.resolve(clients.items)
      , (err) ->  
        $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
        clientDef.reject(err)
 
  ###**
  * @ngdoc method
  * @name $scope.edit
  * @methodOf BBAdminBooking.Controllers:adminBookingClients
  *
  * @description
  * Method $scope.edit
  *
  * @param {object} item item
  *
  * @returns {string} console.log(item)
  *
  ###

  $scope.edit = (item) ->
    console.log item

    