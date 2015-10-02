###**
* @ngdoc service
* @name BB.Services:LoginService
*
* @description
* Factory LoginService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {service} $sessionStorage Info
*
* @param {model} halClient Info
*
* @returns {Promise} This service has the following set of methods:
*
* - companyLogin(company, params, form)
* - login(form, options)
* - companyQuery(id)
* - memberQuery(params)
* - ssoLogin(options, data)
* - isLoggedIn()
* - setLogin(member)
* - member()
* - checkLogin()
* - logout(options)
* - sendPasswordReset(company, params)
* - updatePassword(member, params)
*
###
angular.module('BB.Services').factory "LoginService", ($q, halClient, $rootScope, BBModel, $sessionStorage) ->
  companyLogin: (company, params, form) ->
    deferred = $q.defer()
    company.$post('login', params, form).then (login) =>
      login.$get('member').then (member) =>
        @setLogin(member)
        deferred.resolve(member);
      , (err) =>
        deferred.reject(err)
    , (err) =>
      deferred.reject(err)
    deferred.promise


  login: (form, options) ->
    deferred = $q.defer()
    options['root'] ||= ""
    url = options['root'] + "/api/v1/login"
    halClient.$post(url, options, form).then (login) =>
      params = {auth_token: login.auth_token}
      login.$get('member').then (member) =>
        @setLogin(member)
        deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  companyQuery: (id) =>
    if id
      comp_promise = halClient.$get(location.protocol + '//' + location.host + '/api/v1/company/' + id)
      comp_promise.then (company) =>
        company = new BBModel.Company(company)

  memberQuery: (params) =>
    if params.member_id && params.company_id
      member_promise = halClient.$get(location.protocol + '//' + location.host + "/api/v1/#{params.company_id}/" + "members/" + params.member_id)
      member_promise.then (member) =>
        member = new BBModel.Member.Member(member)

  ssoLogin: (options, data) ->
    deferred = $q.defer()
    options['root'] ||= ""
    url = options['root'] + "/api/v1/login/sso/" + options['company_id']
    halClient.$post(url, {}, data).then (login) =>
      params = {auth_token: login.auth_token}
      login.$get('member').then (member) =>
        member = new BBModel.Member.Member(member)
        @setLogin(member)
        deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise



  # check if we're loggeg in as a member - but not an admin
  isLoggedIn: ->
    @checkLogin()
    if $rootScope.member && !$rootScope.user
      true
    else
      false

  setLogin: (member) ->
    auth_token = member.getOption('auth_token')
    member = new BBModel.Member.Member(member)
    $sessionStorage.setItem("login", member.$toStore())
    $sessionStorage.setItem("auth_token", auth_token)
    $rootScope.member = member
    member

  member: () ->
    @checkLogin()
    $rootScope.member

  checkLogin: () ->
    return if $rootScope.member

    member = $sessionStorage.getItem("login")
    if member
      $rootScope.member = halClient.createResource(member)

  logout: (options) ->

    $rootScope.member = null
    $sessionStorage.removeItem("login")
    $sessionStorage.removeItem('auth_token')
    $sessionStorage.clear()
    deferred = $q.defer()

    options ||= {}
    options['root'] ||= ""
    url = options['root'] + "/api/v1/logout"
    halClient.$del(url, options, {}).then (logout) =>
        deferred.resolve(true)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  sendPasswordReset: (company, params) ->
    deferred = $q.defer()
    company.$post('email_password_reset', {}, params).then () =>
      deferred.resolve(true)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  updatePassword: (member, params) ->
    if member && params['new_password'] && params['confirm_new_password']
      deferred = $q.defer()
      member.$post('update_password', {}, params).then (login) =>
        login.$get('member').then (member) =>
          @setLogin(member)
          deferred.resolve(member)
        , (err) =>
          deferred.reject(err)
      , (err) =>
        deferred.reject(err)
      deferred.promise

