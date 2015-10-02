###**
* @ngdoc controller
* @name BBMember.Controllers:MemberBookings
*
* @description
*{@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller MemberBookingsCtrl
*
* # Has the following set of methods:
*
* - $scope.getUpcomingBookings()
* - $scope.getPastBookings(num, type)
* - $scope.flushBookings()
* - $scope.edit(booking)
* - $scope.cancel(booking)
*   - controller($scope, $rootScope, $modalInstance, booking)
*   - $scope.confirm_delete()
*   - $scope.cancel
*   - booking
* - $scope.getBookings(params)
* - $scope.cancelBooking(booking)
* - $scope.getPrePaidBookings(params)
*
* @requires $scope
* @requires $modal
* @requires $log
* @requires BB.Services:MemberBookingService
* @requires $q
* @requires BB.Services:ModalForm
* @requires BB.Services:MemberPrePaidBookingService
*
###

angular.module('BBMember').controller 'MemberBookings', ($scope, $modal, $log,
    MemberBookingService, $q, ModalForm, MemberPrePaidBookingService) ->

  $scope.loading = true

  ###**
  * @ngdoc method
  * @name $scope.getUpcomingBookings
  * @methodOf BBMember.Controllers:MemberBookings
  * @description
  * <pre>
  * params =
  *   start_date: moment().format('YYYY-MM-DD')
  * $scope.getBookings(params).then (bookings) ->
  *   $scope.upcoming_bookings = bookings
  * </pre>
  *
  ###

  $scope.getUpcomingBookings = () ->
    params =
      start_date: moment().format('YYYY-MM-DD')
    $scope.getBookings(params).then (bookings) ->
      $scope.upcoming_bookings = bookings

  ###**
  * @ngdoc method
  * @name $scope.getPastBooking
  * @methodOf BBMember.Controllers:MemberBookings
  * @description
  * <pre>
  *   date = moment().subtract(num, type)
  * params =
  *   start_date: date.format('YYYY-MM-DD')
  *   end_date: moment().format('YYYY-MM-DD')
  * $scope.getBookings(params).then (bookings) ->
  *   $scope.past_bookings = bookings
  * </pre>
  *
  ###

  $scope.getPastBookings = (num, type) ->
    date = moment().subtract(num, type)
    params =
      start_date: date.format('YYYY-MM-DD')
      end_date: moment().format('YYYY-MM-DD')
    $scope.getBookings(params).then (bookings) ->
      $scope.past_bookings = bookings

  ###**
  * @ngdoc method
  * @name $scope.flushBookings
  * @methodOf BBMember.Controllers:MemberBookings
  * @description
  * <pre>
  *  params =
  *   start_date: moment().format('YYYY-MM-DD')
  * MemberBookingService.flush($scope.member, params)
  * </pre>
  ###

  $scope.flushBookings = () ->
    params =
      start_date: moment().format('YYYY-MM-DD')
    MemberBookingService.flush($scope.member, params)

  ###**
  * @ngdoc method
  * @name $scope.edit
  * @methodOf BBMember.Controllers:MemberBookings
  * @description
  * <pre>
  * booking.getAnswersPromise().then (answers) ->
  *   for answer in answers.answers
  *     booking["question#{answer.question_id}"] = answer.value
  *   ModalForm.edit
  *     model: booking
  *     title: 'Booking Details'
  *     templateUrl: 'edit_booking_modal_form.html'
  *     windowClass: 'member_edit_booking_form'
  * </pre>
  *
  ###

  $scope.edit = (booking) ->
    booking.getAnswersPromise().then (answers) ->
      for answer in answers.answers
        booking["question#{answer.question_id}"] = answer.value
      ModalForm.edit
        model: booking
        title: 'Booking Details'
        templateUrl: 'edit_booking_modal_form.html'
        windowClass: 'member_edit_booking_form'


  ###**
  * @ngdoc method
  * @name $scope.cancel
  * @methodOf BBMember.Controllers:MemberBookings
  * @description
  * <pre>
  *  modalInstance = $modal.open
  *   templateUrl: "member_booking_delete_modal.html"
  *   windowClass: "bbug"
  *   controller: ($scope, $rootScope, $modalInstance, booking) ->
  *     $scope.controller = "ModalDelete"
  *     $scope.booking = booking
  *
  *     $scope.confirm_delete = () ->
  *       $modalInstance.close(booking)
  *
  *     $scope.cancel = ->
  *       $modalInstance.dismiss "cancel"
  *   resolve:
  *     booking: ->
  *       booking
  * modalInstance.result.then (booking) ->
  *   $scope.cancelBooking(booking)
  * </pre>
  *
  ###

  $scope.cancel = (booking) ->
    modalInstance = $modal.open
      templateUrl: "member_booking_delete_modal.html"
      windowClass: "bbug"
      controller: ($scope, $rootScope, $modalInstance, booking) ->
        $scope.controller = "ModalDelete"
        $scope.booking = booking

        $scope.confirm_delete = () ->
          $modalInstance.close(booking)

        $scope.cancel = ->
          $modalInstance.dismiss "cancel"
      resolve:
        booking: ->
          booking
    modalInstance.result.then (booking) ->
      $scope.cancelBooking(booking)

  ###**
  * @ngdoc method
  * @name $scope.getBookings
  * @methodOf BBMember.Controllers:MemberBookings
  * @description
  * <pre>
  *  $scope.loading = true
  * defer = $q.defer()
  * MemberBookingService.query($scope.member, params).then (bookings) ->
  *   $scope.loading = false
  *   defer.resolve(bookings)
  * , (err) ->
  *   $log.error err.data
  *   $scope.loading = false
  * defer.promise
  * </pre>
  *
  ###    

  $scope.getBookings = (params) ->
    $scope.loading = true
    defer = $q.defer()
    MemberBookingService.query($scope.member, params).then (bookings) ->
      $scope.loading = false
      defer.resolve(bookings)
    , (err) ->
      $log.error err.data
      $scope.loading = false
    defer.promise

  ###**
  * @ngdoc method
  * @name $scope.cancelBooking
  * @methodOf BBMember.Controllers:MemberBookings
  * @description
  * <pre>
  *  $scope.loading = true
  * MemberBookingService.cancel($scope.member, booking).then () ->
  *   if $scope.bookings
  *     $scope.bookings = $scope.bookings.filter (b) -> b.id != booking.id
  *   if $scope.removeBooking
  *     $scope.removeBooking(booking)
  *   $scope.loading = false 
  * </pre>
  *
  ###

  $scope.cancelBooking = (booking) ->
    $scope.loading = true
    MemberBookingService.cancel($scope.member, booking).then () ->
      if $scope.bookings
        $scope.bookings = $scope.bookings.filter (b) -> b.id != booking.id
      if $scope.removeBooking
        $scope.removeBooking(booking)
      $scope.loading = false

  ###**
  * @ngdoc method
  * @name $scope.getPrePaidBookings
  * @methodOf BBMember.Controllers:MemberBookings
  * @description
  * <pre>
  * $scope.loading = true
  * defer = $q.defer()
  * MemberPrePaidBookingService.query($scope.member, params).then (bookings) ->
  *   $scope.loading = false
  *   $scope.pre_paid_bookings = bookings
  *   defer.resolve(bookings)
  * , (err) ->
  *   $log.error err.data
  *   $scope.loading = false
  * defer.promise
  * </pre>
  *
  ###

  $scope.getPrePaidBookings = (params) ->
    $scope.loading = true
    defer = $q.defer()
    MemberPrePaidBookingService.query($scope.member, params).then (bookings) ->
      $scope.loading = false
      $scope.pre_paid_bookings = bookings
      defer.resolve(bookings)
    , (err) ->
      $log.error err.data
      $scope.loading = false
    defer.promise
