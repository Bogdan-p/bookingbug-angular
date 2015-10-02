###**
* @ngdoc service
* @name BB.Services:MemberPrePaidBookingService
*
* @description
* Factory MemberPrePaidBookingService
*
* @requires $q
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - query(member, params)
*
###

angular.module('BB.Services').factory "MemberPrePaidBookingService", ($q,
  BBModel) ->

      ###**
      * @ngdoc method
      * @name query
      * @methodOf BB.Services:MemberPrePaidBookingService
      *
      * @description
      * Method refresh
      *
      * @param {object} member member
      * @param {object} params params
      *
      * @returns {Promise} deferred.reject(err) or deferred.promise
      *
      ###

      query: (member, params) ->
        deferred = $q.defer()
        if !member.$has('pre_paid_bookings')
          deferred.reject("member does not have pre paid bookings")
        else
          member.$get('pre_paid_bookings', params).then (bookings) =>
            if angular.isArray bookings
              # pre paid bookings were embedded in member
              bookings = for booking in bookings
                new BBModel.Member.PrePaidBooking(booking)
              deferred.resolve(bookings)
            else
              bookings.$get('pre_paid_bookings', params).then (bookings) =>
                bookings = for booking in bookings
                  new BBModel.Member.PrePaidBooking(booking)
                deferred.resolve(bookings)
          , (err) =>
            deferred.reject(err)
        deferred.promise
