###**
* @ngdoc directive
* @name BBMember.Directives:bbMemberUpcomingBookings
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBMember.Directives:bbMemberUpcomingBookings
*
* # Has the following set of methods:
*
* - link(scope, element, attrs)
*
* @requires $rootScope
*
###

angular.module('BBMember').directive 'bbMemberUpcomingBookings', ($rootScope) ->

  link = (scope, element, attrs) ->
    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    getBookings = () ->
      scope.getUpcomingBookings()

    scope.$on 'updateBookings', () ->
      scope.flushBookings()
      getBookings()

    getBookings()

  {
    link: link
    controller: 'MemberBookings'
    templateUrl: 'member_upcoming_bookings.html'
    scope:
      apiUrl: '@'
      member: '='
  }
