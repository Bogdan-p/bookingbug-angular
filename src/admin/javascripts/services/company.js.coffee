###**
* @ngdoc service
* @name  BBAdmin.Services:AdminCompanyService
*
* @description
* Factory AdminCompanyService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {model} BBModel Info
* <br>
* {@link BBAdmin.Services:AdminBookingService more }
*
* @param {model} AdminLoginService Info
*
* @param {object} $sessionStorage Info
*
###
angular.module('BBAdmin.Services').factory 'AdminCompanyService', ($q,
    BBModel, AdminLoginService, $rootScope, $sessionStorage) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminCompanyService
  *
  * @description
  * Method query
  *
  * @param {object} params Info
  *
  * @returns {Promise} deferred.promise
  ###
  query: (params) ->
    defer = $q.defer()
    $rootScope.bb ||= {}

    $rootScope.bb.api_url ||= $sessionStorage.getItem("host")
    $rootScope.bb.api_url ||= params.apiUrl
    $rootScope.bb.api_url ||= ""

    AdminLoginService.checkLogin(params).then () ->
      if $rootScope.user && $rootScope.user.company_id
        $rootScope.bb ||= {}
        $rootScope.bb.company_id = $rootScope.user.company_id
        $rootScope.user.$get('company').then (company) ->
          defer.resolve(BBModel.Company(company))
        , (err) ->
          defer.reject(err)
      else
        login_form =
          email: params.adminEmail
          password: params.adminPassword
        options =
          company_id: params.companyId
        AdminLoginService.login(login_form, options).then (user) ->
          user.$get('company').then (company) ->
            defer.resolve(BBModel.Company(company))
          , (err) ->
            defer.reject(err)
        , (err) ->
          defer.reject(err)
    defer.promise

