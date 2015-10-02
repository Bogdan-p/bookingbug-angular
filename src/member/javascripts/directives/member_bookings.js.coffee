###**
* @ngdoc directive
* @name BBMember.Directives:memberBookings
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBMember.Directives:memberBookings
*
* # Has the following set of methods:
*
* - link(scope, element, attrs)
*
* @requires $rootScope
*
###

angular.module('BBMember').directive 'memberBookings', ($rootScope) ->

  link = (scope, element, attrs) ->
    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

  {
    link: link
    templateUrl: 'member_bookings_tabs.html'
    scope:
      apiUrl: '@'
      member: '='
  }
