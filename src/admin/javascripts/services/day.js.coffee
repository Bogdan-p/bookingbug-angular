###**
* @ngdoc service
* @name  BBAdmin.Services:AdminDayService
*
* @description
* Factory AdminDayService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {object} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window read more}
*
* @param {model} halClient Info
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
angular.module('BBAdmin.Services').factory 'AdminDayService', ($q, $window,
    halClient, BBModel, UriTemplate) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminDayService
  *
  * @description
  * Method query
  *
  * @param {object} prms Info
  *
  * @returns {Promise} deferred.promise
  ###
  query: (prms) ->
    url = ""
    url = prms.url if prms.url
    href = url + "/api/v1/{company_id}/day_data{?month,week,date,edate,event_id,service_id}"

    uri = new UriTemplate(href).fillFromObject(prms || {})
    deferred = $q.defer()
    halClient.$get(uri, {}).then  (found) =>
      if found.items
        mdays = []
        # it has multiple days of data
        for item in found.items
          halClient.$get(item.uri).then (data) ->
            days = []
            for i in data.days
              if (i.type == prms.item)
                days.push(new BBModel.Day(i))
            dcol = new $window.Collection.Day(data, days, {})
            mdays.push(dcol)
        deferred.resolve(mdays)
    , (err) =>
      deferred.reject(err)

    deferred.promise
