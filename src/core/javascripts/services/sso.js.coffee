###**
* @ngdoc service
* @name BB.Services:SSOService
*
* @description
* Factory SSOService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {model} halClient Info
*
* @returns {Promise} This service has the following set of methods:
*
* - memberLogin(options)
* - adminLogin: (options)
*
###
angular.module('BB.Services').factory "SSOService", ($q, $rootScope, halClient, LoginService) ->

  memberLogin: (options) ->
    deferred = $q.defer()
    options.root ||= ""
    url = options.root + "/api/v1/login/sso/" + options.company_id
    data = {token: options.member_sso}
    halClient.$post(url, {}, data).then (login) =>
      params = {auth_token: login.auth_token}
      login.$get('member').then (member) =>
        member = LoginService.setLogin(member)
        deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  adminLogin: (options) ->
    deferred = $q.defer()
    options.root ||= ""
    url = options.root + "/api/v1/login/admin_sso/" + options.company_id
    data = {token: options.admin_sso}
    halClient.$post(url, {}, data).then (login) =>
      params = {auth_token: login.auth_token}
      login.$get('administrator').then (admin) =>
        deferred.resolve(admin)
    , (err) =>
      deferred.reject(err)
    deferred.promise
