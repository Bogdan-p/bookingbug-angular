###**
* @ngdoc service
* @name BB.Services:AddressListService
*
* @description
* Factory AddressListService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @param {model} halClient Info
*
* @param {model} UriTemplate Info
* <br>
* {@link UriTemplate more}
*
* @returns {Promise} This service has the following set of methods:
*
* - query(prms)
* - getAddress(prms)
*
###
angular.module('BB.Services').factory "AddressListService", ($q, $window, halClient, UriTemplate) ->
 query: (prms) ->

    deferred = $q.defer()
    href = "/api/v1/company/{company_id}/addresses/{post_code}"
    uri = new UriTemplate(href).fillFromObject({company_id: prms.company.id, post_code: prms.post_code })
    halClient.$get(uri, {}).then (addressList) ->
      deferred.resolve(addressList)
    , (err) =>
      deferred.reject(err)
    deferred.promise

 getAddress: (prms) ->
   deferred = $q.defer()
   href = "/api/v1/company/{company_id}/addresses/address/{id}"
   uri = new UriTemplate(href).fillFromObject({company_id: prms.company.id, id: prms.id})
   halClient.$get(uri, {}).then (customerAddress) ->
     deferred.resolve(customerAddress)
   , (err) =>
     deferred.reject(err)
   deferred.promise
