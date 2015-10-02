###**
* @ngdoc directive
* @name BBMember.Directives:bbMemberPrePaidBookings
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBMember.Directives:bbMemberPrePaidBookings
*
* # Has the following set of methods:
*
* -  link(scope, element, attrs)
*    - getBookings()
*
* @requires $rootScope
*
###

angular.module('BBMember').directive 'bbMemberPrePaidBookings', ($rootScope) ->

  link = (scope, element, attrs) ->
    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    scope.loading = true

    getBookings = () ->
      scope.getPrePaidBookings({}).finally () ->
        scope.loading = false

    getBookings()

  {
    link: link
    controller: 'MemberBookings'
    templateUrl: 'member_pre_paid_bookings.html'
    scope:
      apiUrl: '@'
      member: '='
  }
