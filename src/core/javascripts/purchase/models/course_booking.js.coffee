###**
* @ngdoc object
* @name BB.Models:Purchase.CourseBookingModel
*
* @description
* This is Pourse Booking in BB.Models module that creates Course Booking object.
*
* <pre>
* //Creates class Purchase_Course_Booking that extends BaseModel
* class Purchase_Course_Booking extends BaseModel
* </pre>
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
*
* @returns {Promise} Newly created Course Booking object with the following set of methods:
*
* - constructor(data)
* - getBookings
*
###

angular.module('BB.Models').factory "Purchase.CourseBookingModel", ($q, BBModel, BaseModel) ->

  class Purchase_Course_Booking extends BaseModel
    constructor: (data) ->
      super(data)

    getBookings: =>
      defer = $q.defer()
      defer.resolve(@bookings) if @bookings
      if @_data.$has('bookings')
        @_data.$get('bookings').then (bookings) =>
          @bookings = (new BBModel.Purchase.Booking(b) for b in bookings)
          @bookings.sort (a, b) => a.datetime.unix() - b.datetime.unix()
          defer.resolve(@bookings)
      else
        @bookings = []
        defer.resolve(@bookings)
      defer.promise
