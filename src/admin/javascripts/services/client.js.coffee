###**
* @ngdoc service
* @name  BBAdmin.Services:AdminClientService
*
* @description
* Factory AdminClientService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {object} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {model} halClient Info
*
* @param {model} ClientCollections Info
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} UriTemplate Info
* <br>
* {@link UriTemplate more}
*
###
angular.module('BBAdmin.Services').factory 'AdminClientService',  ($q, $window,
    $rootScope, halClient, ClientCollections, BBModel, UriTemplate) ->

  ###**
  * @ngdoc query
  * @name sinceStart
  * @methodOf BBAdmin.Services:AdminClientService
  *
  * @description
  * Method query
  *
  * @param {Promise} prms Info
  *
  * @returns {Promise} deferred.promise
  ###
  query: (prms) ->
    if prms.company
      prms.company_id = prms.company.id
    url = ""
    url = $rootScope.bb.api_url if $rootScope.bb.api_url
    href = url + "/api/v1/admin/{company_id}/client{/id}{?page,per_page,filter_by,filter_by_fields,order_by,order_by_reverse}"

    uri = new UriTemplate(href).fillFromObject(prms || {})
    deferred = $q.defer()
    halClient.$get(uri, {}).then  (resource) =>
      if resource.$has('clients')
        resource.$get('clients').then (items) =>
          people = []
          for i in items
            people.push(new BBModel.Client(i))
          clients  = new $window.Collection.Client(resource, people, prms)
          clients.total_entries = resource.total_entries
          ClientCollections.add(clients)
          deferred.resolve(clients)
      else
        client = new BBModel.Client(resource)
        deferred.resolve(client)
    , (err) =>
      deferred.reject(err)

    deferred.promise

  ###**
  * @ngdoc method
  * @name update
  * @methodOf BBAdmin.Services:AdminClientService
  *
  * @description
  * Method update
  *
  * @param {object} client Info
  *
  * @returns {Promise} deferred.promise
  ###
  update: (client) ->
    deferred = $q.defer()
    client.$put('self', {}, client).then (res) =>
      deferred.resolve(new BBModel.Client(res))
    , (err) =>
      deferred.reject(err)
    deferred.promise


