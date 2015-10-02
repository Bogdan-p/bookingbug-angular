###**
* @ngdoc directive
* @name BB.Directives:AdminBookingPopup
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BB.Directives:AdminBookingPopup
*
* # Has the following set of methods:
*
* - controller($scope)
* - link(scope, element, attrs)
*
* @requires BB.Directives:AdminBookingPopup
*
###

angular.module('BBAdminBooking').directive 'bbAdminBookingPopup', (AdminBookingPopup) ->

  controller = ($scope) ->

    $scope.open = () ->
      AdminBookingPopup.open()

  link = (scope, element, attrs) ->
    element.bind 'click', () ->
      scope.open()

  {
    link: link
    controller: controller
  }
