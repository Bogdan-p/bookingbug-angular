
###**
* @ngdoc directive
* @name BB.Directives:bbLogin
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbLogin
*
* See Controller {@link BB.Controllers:Login Login}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'Login'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbLogin', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Login'

###**
* @ngdoc controller
* @name BB.Controllers:Login
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller Login
*
* # Has the following set of methods:
*
* - $scope.login_sso(token, route)
* - $scope.login_with_password(email, password)
* - $scope.showEmailPasswordReset()
* - $scope.isLoggedIn()
* - $scope.sendPasswordReset(email)
* - $scope.updatePassword(new_password, confirm_new_password)
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} LoginService Info
* <br>
* {@link BB.Services:LoginService more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
*
###
angular.module('BB.Controllers').controller 'Login', ($scope,  $rootScope, LoginService, $q, ValidatorService, BBModel, $location) ->
  $scope.controller = "public.controllers.Login"
  $scope.error = false
  $scope.password_updated = false
  $scope.password_error = false
  $scope.email_sent = false
  $scope.success = false
  $scope.login_error = false
  $scope.validator = ValidatorService

  $scope.login_sso = (token, route) =>
    $rootScope.connection_started.then =>
      LoginService.ssoLogin({company_id: $scope.bb.company.id, root: $scope.bb.api_url}, {token: token}).then (member) =>
        $scope.showPage(route) if route
      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.login_with_password = (email, password) =>
    $scope.login_error = false
    LoginService.companyLogin($scope.bb.company, {}, {email: email, password: password}).then (member) =>
      $scope.member = new BBModel.Member.Member(member)
      $scope.success = true
      $scope.login_error = false
    , (err) =>
      $scope.login_error = err

  $scope.showEmailPasswordReset = () =>
    $scope.showPage('email_reset_password')

  $scope.isLoggedIn = () =>
    LoginService.isLoggedIn()

  $scope.sendPasswordReset = (email) =>
    $scope.error = false
    LoginService.sendPasswordReset($scope.bb.company, {email: email, custom: true}).then () =>
      $scope.email_sent = true
    , (err) =>
      $scope.error = err

  $scope.updatePassword = (new_password, confirm_new_password) =>
    auth_token = $scope.member.getOption('auth_token')
    $scope.password_error = false
    $scope.error = false
    if $scope.member && auth_token && new_password && confirm_new_password && (new_password == confirm_new_password)
      LoginService.updatePassword($rootScope.member, {auth_token: auth_token, new_password: new_password, confirm_new_password: confirm_new_password}).then (member) =>
        if member
          $scope.password_updated = true
          $scope.showPage('login')
      , (err) =>
        $scope.error = err
    else
      $scope.password_error = true
