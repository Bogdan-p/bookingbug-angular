###**
* @ngdoc directive
* @name BBAdmin.Directives:bookingTable
* @restrict E
*
* @description
* Directive bookingTable
*
* @param {service} $modal $modal is a service to quickly create AngularJS-powered modal windows. Creating custom modals is straightforward: create a partial view, its controller and reference them when using the service.
* <br>
* {@link https://github.com/angular-ui/bootstrap/tree/master/src/modal/docs read more}
*
* @param {service} $log Simple service for logging.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$log read more}
*
* @param {service} AdminCompanyService Service AdminCompanyService
* @param {service} AdminBookingService Service AdminBookingService
* @param {service} ModalForm Service ModalForm
*
* @example Example that demonstrates basic bookingTable.
  <example>
    <file name="index.html">
      <div class="my-example">
      </div>
    </file>

    <file name="style.css">
      .my-example {
        background: green;
        widht: 200px;
        height: 200px;
      }
    </file>
  </example>
###
angular.module('BBAdmin').directive 'bookingTable', (AdminCompanyService,
    AdminBookingService, $modal, $log, ModalForm) ->

  controller = ($scope) ->

    $scope.fields = ['id', 'datetime']

    $scope.getBookings = () ->
      params =
        company: $scope.company
      AdminBookingService.query(params).then (bookings) ->
        $scope.bookings = bookings

    $scope.newBooking = () ->
      ModalForm.new
        company: $scope.company
        title: 'New Booking'
        new_rel: 'new_booking'
        post_rel: 'bookings'
        success: (booking) ->
          $scope.bookings.push(booking)

    $scope.edit = (booking) ->
      ModalForm.edit
        model: booking
        title: 'Edit Booking'

  link = (scope, element, attrs) ->
    if scope.company
      scope.getBookings()
    else
      AdminCompanyService.query(attrs).then (company) ->
        scope.company = company
        scope.getBookings()

  {
    controller: controller
    link: link
    templateUrl: 'booking_table_main.html'
  }
