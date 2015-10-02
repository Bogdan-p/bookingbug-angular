###**
* @ngdoc controller
* @name BBAdmin.Controllers:SelectedBookingDetails
*
* @description
* Controller SelectedBookingDetails
*
* @param {object} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {service} $location The $location service parses the URL in the browser address bar
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$location read more}
*
* @param {service} AdminBookingService Service.
*
###
angular.module('BBAdmin.Controllers').controller 'SelectedBookingDetails', ($scope,  $location, AdminBookingService, $rootScope) ->


  $scope.$watch 'selectedBooking', (newValue, oldValue) =>
    if newValue
      $scope.booking = newValue
      $scope.showItemView = "/view/dash/booking_details"
#      $scope.bookings = AdminBookingService.query({company_id: $scope.bb.company_id, slot: newValue})
#      $scope.bookings.then (bkngs) =>
#        if bkngs.items.length > 0
#          $scope.booking = bkngs.items[0]
#          $scope.showItemView = "/view/dash/booking_details"
