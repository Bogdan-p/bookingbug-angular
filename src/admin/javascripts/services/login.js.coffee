###**
* @ngdoc service
* @name  BBAdmin.Services:AdminLoginService
*
* @description
* Factory AdminLoginService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {service} $cookies Provides read/write access to browser's cookies.
* <br>
* {@link https://docs.angularjs.org/api/ngCookies/service/$cookies read more}
*
* @param {model} halClient Info
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {object} $sessionStorage Info
*
* @param {model} UriTemplate Info
* <br>
* {@link UriTemplate more}
*
###
angular.module('BBAdmin.Services').factory "AdminLoginService", ($q, halClient,
    $rootScope, BBModel, $sessionStorage, $cookies, UriTemplate) ->

  ###**
  * @ngdoc method
  * @name login
  * @methodOf BBAdmin.Services:AdminLoginService
  *
  * @description
  * Method login
  *
  * @param {object} form Info
  *
  * @param {object} options Info
  *
  * @returns {Promise} deferred.promise
  ###
  login: (form, options) ->
    deferred = $q.defer()
    url = "#{$rootScope.bb.api_url}/api/v1/login/admin"
    if (options? && options.company_id?)
      url = "#{url}/#{options.company_id}"

    halClient.$post(url, options, form).then (login) =>
      if login.$has('administrator')
        login.$get('administrator').then (user) =>
          user = @setLogin(user)
          deferred.resolve(user)
      else if login.$has('administrators')
        login_model = new BBModel.Admin.Login(login)
        deferred.resolve(login_model)
      else
        deferred.reject("No admin account for login")
    , (err) =>
      if err.status == 400
        login = halClient.$parse(err.data)
        if login.$has('administrators')
          login_model = new BBModel.Admin.Login(login)
          deferred.resolve(login_model)
        else
          deferred.reject(err)
      else
        deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name ssoLogin
  * @methodOf BBAdmin.Services:AdminLoginService
  *
  * @description
  * Method ssoLogin
  *
  * @param {object} options Info
  *
  * @param {object} data Info
  *
  * @returns {Promise} deferred.promise
  ###
  ssoLogin: (options, data) ->
    deferred = $q.defer()
    url = $rootScope.bb.api_url + "/api/v1/login/sso/" + options['company_id']

    halClient.$post(url, {}, data).then (login) =>
      params = {auth_token: login.auth_token}
      login.$get('user').then (user) =>
        user = @setLogin(user)
        deferred.resolve(user)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name isLoggedIn
  * @methodOf BBAdmin.Services:AdminLoginService
  *
  * @description
  * Method isLoggedIn
  *
  * @returns {Boolean} returns true if user is logged in otherwise returns false
  ###
  isLoggedIn: ->
    @checkLogin().then () ->
      if $rootScope.user
        true
      else
        false

  ###**
  * @ngdoc method
  * @name setLogin
  * @methodOf BBAdmin.Services:AdminLoginService
  *
  * @description
  * Method setLogin
  *
  * @param {object} user Info
  *
  * @returns {object} returns newly created user object
  ###
  setLogin: (user) ->
    auth_token = user.getOption('auth_token')
    user = new BBModel.Admin.User(user)
    $sessionStorage.setItem("user", user.$toStore())
    $sessionStorage.setItem("auth_token", auth_token)
    $rootScope.user = user
    user

  ###**
  * @ngdoc method
  * @name user
  * @methodOf BBAdmin.Services:AdminLoginService
  *
  * @description
  * Method user
  *
  * @returns {object} returns $rootScope.use
  ###
  user: () ->
    @checkLogin().then () ->
      $rootScope.user

  ###**
  * @ngdoc method
  * @name checkLogin
  * @methodOf BBAdmin.Services:AdminLoginService
  *
  * @description
  * Method checkLogin
  *
  * @returns {Promise} defer.resolve() or defer.promise
  ###
  checkLogin: (params = {}) ->
    defer = $q.defer()
    defer.resolve() if $rootScope.user
    user = $sessionStorage.getItem("user")
    if user
      $rootScope.user = new BBModel.Admin.User(halClient.createResource(user))
      defer.resolve()
    else
      auth_token = $cookies['Auth-Token']
      if auth_token
        if $rootScope.bb.api_url
          url = "#{$rootScope.bb.api_url}/api/v1/login{?id,role}"
        else
          url = "/api/v1/login{?id,role}"
        params.id = params.companyId || params.company_id
        params.role = 'admin'
        href = new UriTemplate(url).fillFromObject(params || {})
        options = {auth_token: auth_token}
        halClient.$get(href, options).then (login) =>
          if login.$has('administrator')
            login.$get('administrator').then (user) ->
              $rootScope.user = new BBModel.Admin.User(user)
              defer.resolve()
          else
            defer.resolve()
        , () ->
          defer.resolve()
      else
        defer.resolve()
    defer.promise

  ###**
  * @ngdoc method
  * @name logout
  * @methodOf BBAdmin.Services:AdminLoginService
  *
  * @description
  * Method logout
  *
  * @returns {Promise} defer.reject or defer.promise
  ###
  logout: () ->
    $rootScope.user = null
    $sessionStorage.removeItem("user")
    $sessionStorage.removeItem("auth_token")
    $cookies['Auth-Token'] = null

  ###**
  * @ngdoc method
  * @name getLogin
  * @methodOf BBAdmin.Services:AdminLoginService
  *
  * @description
  * Method getLogin
  *
  * @param {object} options Info
  *
  * @returns {Promise} defer.reject or defer.promise
  ###
  getLogin: (options) ->
    defer = $q.defer()
    url = "#{$rootScope.bb.api_url}/api/v1/login/admin/#{options.company_id}"
    halClient.$get(url, options).then (login) =>
      if login.$has('administrator')
        login.$get('administrator').then (user) =>
          user = @setLogin(user)
          defer.resolve(user)
        , (err) ->
          defer.reject(err)
      else
        defer.reject()
    , (err) ->
      defer.reject(err)
    defer.promise

