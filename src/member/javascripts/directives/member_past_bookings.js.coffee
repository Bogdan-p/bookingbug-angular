###**
* @ngdoc directive
* @name BBMember.Directives:bbMemberPastBookings
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBMember.Directives:bbMemberPastBookings
*
* # Has the following set of methods:
*
* -  link(scope, element, attrs)
*    - getBookings()
*
* @requires $rootScope
*
###

angular.module('BBMember').directive 'bbMemberPastBookings', ($rootScope) ->

  link = (scope, element, attrs) ->
    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    getBookings = () ->
      scope.getPastBookings()

    getBookings()

  {
    link: link
    controller: 'MemberBookings'
    templateUrl: 'member_past_bookings.html'
    scope:
      apiUrl: '@'
      member: '='
  }
