###**
* @ngdoc directive
* @name BBMember.Directives:memberForm
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBMember.Directives:memberForm
*
* # Has the following set of methods:
*
* - controller($scope)
* - $scope.submit(form)
* - link(scope, element, attrs)
*
* @requires $modal
* @requires $log
* @requires $rootScope
* @requires BBMember.Services:MemberLoginService
* @requires BB.Services:MemberBookingService
*
###

angular.module('BBMember').directive 'memberForm', ($modal, $log, $rootScope,
    MemberLoginService, MemberBookingService) ->

  controller = ($scope) ->
    $scope.loading = true

    $scope.$watch 'member', (member) ->
      if member?
        member.$get('edit_member').then (member_schema) ->
          $scope.form = member_schema.form
          $scope.schema = member_schema.schema
          $scope.loading = false

    $scope.submit = (form) ->
      $scope.loading = true
      $scope.member.$put('self', {}, form).then (member) ->
        $log.info "Successfully updated member"
        $scope.loading = false
      , (err) ->
        $log.error "Failed to update member - #{err}"
        $scope.loading = false

  link = (scope, element, attrs) ->
    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= attrs.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

  {
    link: link
    controller: controller
    template: """
<form sf-schema="schema" sf-form="form" sf-model="member"
  ng-submit="submit(member)" ng-hide="loading"></form>
    """
  }
