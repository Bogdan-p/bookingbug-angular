###**
* @ngdoc service
* @name BB.Services:CustomTextService
*
* @description
* Factory CustomTextService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @returns {Promise} This service has the following set of methods:
*
* - BookingText(company, basketItem)
* - confirmationText(company, total)
*
###
angular.module('BB.Services').factory "CustomTextService",  ($q, BBModel) ->
  BookingText: (company, basketItem) ->
    deferred = $q.defer()
    company.$get('booking_text').then (emb) =>
      emb.$get('booking_text').then (details) =>
        msgs = []
        for detail in details
          if detail.message_type == "Booking"
            for name, link of basketItem.parts_links
              if detail.$href('item') == link
                if msgs.indexOf(detail.message) == -1
                  msgs.push(detail.message)
        deferred.resolve(msgs)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  confirmationText: (company, total) ->
    deferred = $q.defer()
    company.$get('booking_text').then (emb) ->
      emb.$get('booking_text').then (details) ->
        total.getMessages(details, "Confirm").then (msgs) ->
          deferred.resolve(msgs)
    , (err) ->
      deferred.reject(err)
    deferred.promise
