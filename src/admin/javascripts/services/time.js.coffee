###**
* @ngdoc service
* @name  BBAdmin.Services:AdminTimeService
*
* @description
* Factory AdminTimeService
*
 @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
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
angular.module('BBAdmin.Services').factory 'AdminTimeService', ($q, $window,
    halClient, BBModel, UriTemplate) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminTimeService
  *
  * @description
  * Method query
  *
  * @param {object} prms Info
  *
  * @returns {Promise} defer.reject(err) or deferred.promise
  ###
  query: (prms) ->
    if prms.day
      prms.date = prms.day.date
    if !prms.edate && prms.date
      prms.edate = prms.date
    url = ""
    url = prms.url if prms.url
    href = url + "/api/v1/{company_id}/time_data{?date,event_id,service_id,person_id}"

    uri = new UriTemplate(href).fillFromObject(prms || {})
    deferred = $q.defer()
    halClient.$get(uri, { no_cache: false }).then (found) =>
      found.$get('events').then (events) =>
        eventItems = []
        for eventItem in events
          event = {}
          event.times = []
          event.event_id = eventItem.event_id
          event.person_id = found.person_id
          for time in eventItem.times
            ts = new BBModel.TimeSlot(time)
            event.times.push(ts)
          eventItems.push(event)
        deferred.resolve(eventItems)
    , (err) =>
      deferred.reject(err)

    deferred.promise
