###**
* @ngdoc service
* @name BBAdminBooking.Services:AdminBookingPopup
*
* @description
* Factory AdminBookingPopup
*
* path: src/admin-booking/javascripts/services/admin_booking_popup.js.coffee
*
* @requires $modal
* @requires $timeout
*
* @returns {object} This service has the following set of methods:
*
* - opem(config)
* - controller($scope, $modalInstance, config
* - $scope.cancel()
* - config()
*
###

angular.module('BBAdminBooking').factory 'AdminBookingPopup', ($modal, $timeout) ->

  ###**
  * @ngdoc method
  * @name config
  * @methodOf BBAdmin.Services:AdminAdministratorService
  *
  * @description
  * Method config
  *
  * @param {object} config config
  *
  ###

  open: (config) ->
    $modal.open
      size: config.size || 'lg'

      ###**
      * @ngdoc method
      * @name controller
      * @methodOf BBAdmin.Services:AdminAdministratorService
      *
      * @description
      * Method controller
      *
      * @param {object} $scope $scope
      * @param {object} $modalInstance $modalInstance
      * @param {object} config config
      *
      * @return {object} config
      *
      ###

      controller: ($scope, $modalInstance, config) ->
        $scope.config = angular.extend
          company_id: $scope.company.id
          item_defaults:
            merge_resources: true
            merge_people: true
          clear_member: true
          template: 'main'
        , config
        $scope.cancel = () ->
          $modalInstance.dismiss('cancel')
      templateUrl: 'admin_booking_popup.html'
      resolve:
        config: () -> config
