###**
* @ngdoc service
* @name BB.Services:PurchaseService
*
* @description
* Factory PurchaseService
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
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @returns {Promise} This service has the following set of methods:
*
* - query(params)
* - more mthods
*
###
angular.module('BB.Services').factory "PurchaseService", ($q, halClient, BBModel, $window, UriTemplate) ->

  query: (params) ->
    defer = $q.defer()
    uri = params.url_root+"/api/v1/purchases/"+params.purchase_id
    halClient.$get(uri, params).then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) ->
      defer.reject(err)
    defer.promise


  bookingRefQuery: (params) ->
    defer = $q.defer()
    uri = new UriTemplate(params.url_root + "/api/v1/purchases/booking_ref/{booking_ref}{?raw}").fillFromObject(params)
    halClient.$get(uri, params).then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) ->
      defer.reject(err)
    defer.promise


  update: (params) ->
    defer = $q.defer()

    if !params.purchase
      defer.reject("No purchase present")
      return defer.promise

    # only send email on the last item we're moving - otherwise we'll send an email on each item!
    data = {}

    if params.bookings
      bdata = []
      for booking in params.bookings
        bdata.push(booking.getPostData())
      data.bookings = bdata

    params.purchase.$put('self', {}, data).then (purchase) =>
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) =>
      defer.reject(err)
    defer.promise

   bookWaitlistItem: (params) ->
    defer = $q.defer()
    if !params.purchase
      defer.reject("No purchase present")
      return defer.promise
    data = {}
    data.booking = params.booking.getPostData()  if params.booking
    data.booking_id = data.booking.id
    params.purchase.$put('book_waitlist_item', {}, data).then (purchase) =>
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) =>
      defer.reject(err)
    defer.promise


  delete_all: (purchase) ->

    defer = $q.defer()

    if !purchase
      defer.reject("No purchase present")
      return defer.promise

    purchase.$del('self').then (purchase) ->
      purchase = new BBModel.Purchase.Total(purchase)
      defer.resolve(purchase)
    , (err) =>
      defer.reject(err)

    defer.promise
