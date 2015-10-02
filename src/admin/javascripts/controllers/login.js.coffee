###**
* @ngdoc directive
* @name BBAdmin.Directives:bbAdminLogin
* @restrict AE
*
* @description
* Directive bbAdminLogin
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
angular.module('BBAdmin.Directives').directive 'bbAdminLogin', () ->

  restrict: 'AE'
  replace: true
  scope: {
    onSuccess: '='
    onCancel: '='
    onError: '='
    bb: '='
  }
  controller: 'AdminLogin'
  template: '<div ng-include="login_template"></div>'

###**
* @ngdoc controller
* @name BBAdmin.Controllers:AdminLogin
*
* @description
* Controller AdminLogin
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {object} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {object} $sessionStorage The $location service parses the URL in the browser address bar
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$location read more}
*
* @param {service} AdminLoginService Service.
*
###
angular.module('BBAdmin.Controllers').controller 'AdminLogin', ($scope,
    $rootScope, AdminLoginService, $q, $sessionStorage) ->

  $scope.login =
    host: $sessionStorage.getItem('host')
    email: null
    password: null

  $scope.login_template = 'admin_login.html'

  $scope.login = () ->
    $scope.alert = ""
    params =
      email: $scope.login.email
      password: $scope.login.password
    AdminLoginService.login(params).then (user) ->
      if user.company_id?
        $scope.user = user
        $scope.onSuccess() if $scope.onSuccess
      else
        user.getAdministratorsPromise().then (administrators) ->
          $scope.administrators = administrators
          $scope.pickCompany()
    , (err) ->
      $scope.alert = "Sorry, either your email or password was incorrect"

  $scope.pickCompany = () ->
    $scope.login_template = 'pick_company.html'

  $scope.selectedCompany = () ->
    $scope.alert = ""
    params =
      email: $scope.email
      password: $scope.password
    $scope.selected_admin.$post('login', {}, params).then (login) ->
      $scope.selected_admin.getCompanyPromise().then (company) ->
        $scope.bb.company = company
        AdminLoginService.setLogin($scope.selected_admin)
        $scope.onSuccess(company)

