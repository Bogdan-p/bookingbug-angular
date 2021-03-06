###**
* @ngdoc controller
* @name BBAdmin.Controllers:DashboardContainer
*
* @description
* Controller DashboardContainer
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
* @param {service} $modal is a service to quickly create AngularJS-powered modal windows. Creating custom modals is straightforward: create a partial view, its controller and reference them when using the service.
* <br>
* {@link https://github.com/angular-ui/bootstrap/tree/master/src/modal/docs read more}
*
###
angular.module('BBAdmin.Controllers').controller 'DashboardContainer', ($scope,  $rootScope, $location, $modal) ->

  $scope.selectedBooking = null
  $scope.poppedBooking = null

  $scope.selectBooking = (booking) ->
    $scope.selectedBooking = booking

  $scope.popupBooking = (booking) ->
    $scope.poppedBooking = booking

    modalInstance = $modal.open {
      templateUrl: 'full_booking_details',
      controller: ModalInstanceCtrl,
      scope: $scope,
      backdrop: true,
      resolve: {
        items: () => {booking: booking};
      }
    }

    modalInstance.result.then (selectedItem) =>
      $scope.selected = selectedItem;
    , () =>
      console.log('Modal dismissed at: ' + new Date())

  ModalInstanceCtrl = ($scope, $modalInstance, items) ->
    angular.extend($scope, items)
    $scope.ok = () ->
      console.log "closeing", items,
      if items.booking && items.booking.self
        items.booking.$update()
      $modalInstance.close();
    $scope.cancel = () ->
      $modalInstance.dismiss('cancel');

  # a popup performing an action on a time, possible blocking, or mkaing a new booking
  $scope.popupTimeAction = (prms) ->
    console.log(prms)

    modalInstance = $modal.open {
      templateUrl: $scope.partial_url + 'time_popup',
      controller: ModalInstanceCtrl,
      scope: $scope,
      backdrop: false,
      resolve: {
        items: () => prms;
      }
    }

