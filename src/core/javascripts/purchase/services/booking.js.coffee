'use strict';

###**
* @ngdoc service
* @name BB.Services:PurchaseBookingService
*
* @description
* {@link https://docs.angularjs.org/guide/services more about Services}
*
* Factory PurchaseBookingService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {model} halClient Info
* <br>
* {@link angular-hal:halClient more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
*
* @returns {Promise} This service has the following set of methods:
*
* - update(booking)
* - addSurveyAnswersToBooking(booking)
###
angular.module('BB.Services').factory "PurchaseBookingService", ($q, halClient, BBModel) ->

  update: (booking) ->
    deferred = $q.defer()
    data = booking.getPostData()
    booking.srcBooking.$put('self', {}, data).then (booking) =>
      deferred.resolve(new BBModel.Purchase.Booking(booking))
    , (err) =>
      deferred.reject(err, new BBModel.Purchase.Booking(booking))
    deferred.promise

  addSurveyAnswersToBooking: (booking) ->
    deferred = $q.defer()
    data = booking.getPostData()
    booking.$put('self', {}, data).then (booking) =>
      deferred.resolve(new BBModel.Purchase.Booking(booking))
    , (err) =>
      deferred.reject(err, new BBModel.Purchase.Booking(booking))
    deferred.promise
