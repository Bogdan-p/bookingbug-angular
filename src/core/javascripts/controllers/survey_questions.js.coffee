###**
* @ndgoc directive
* @name BB.Directives:bbSurveyQuestions
*
* @restrict AE
* @scope true
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BB.Directives:bbSurveyQuestions
*
* # Has the following set of methods:
*
###

angular.module('BB.Directives').directive 'bbSurveyQuestions', () ->
  restrict: 'AE'
  replace: true
  scope: true
  controller : 'SurveyQuestions'

###**
* @ngdoc controller
* @name BB.Controllers:SurveyQuestions
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller SurveyQuestions
*
* # Has the following set of methods:
*
* - $scope.init(comp)
* - $scope.checkIfLoggedIn()
* - $scope.loadSurvey(purchase)
* - $scope.submitSurveyLogin(form)
* - $scope.loadSurveyFromPurchaseID(id)
* - $scope.loadSurveyFromBookingRef(id)
* - $scope.submitSurvey(form)
* - $scope.submitBookingRef(form)
* - $scope.storeBookingCookie()
* - showLoginError()
* - getMember()
* - setPurchaseCompany(company)
* - getBookingRef()
* - getPurchaseID()
* - getBookingAndSurvey()
*
* @requires $scope
* @requires $rootScope
* @requires BB.Services:CompanyService
* @requires BB.Services:PurchaseService
* @requires BB.Services:ClientService
* @requires $modal
* @requires $location
* @requires $timeout
* @requires BB.Models:BBWidget
* @requires BB.Models:BBModel
* @requires $q
* @requires BB.Services:QueryStringService
* @requires BB.Services:SSOService
* @requires BB.Services:AlertService
* @requires BB.Services:LoginService
* @requires $window
* @requires $upload
* @requires BB.Services:ServiceService
* @requires BB.Services:ValidatorService
* @requires BB.Services:PurchaseBookingService
* @requires $sessionStorage
*
###

angular.module('BB.Controllers').controller 'SurveyQuestions', ($scope,  $rootScope,
    CompanyService, PurchaseService, ClientService, $modal, $location, $timeout,
    BBWidget, BBModel, $q, QueryStringService, SSOService, AlertService,
    LoginService, $window, $upload, ServiceService, ValidatorService, PurchaseBookingService, $sessionStorage) ->

  $scope.controller = "SurveyQuestions"

  $scope.completed = false
  $scope.login = {email: "", password: ""}
  $scope.login_error = false
  $scope.booking_ref = ""

  $scope.notLoaded $scope

  $rootScope.connection_started.then ->
    init()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  init = () =>
    if $scope.company 
      if $scope.company.settings.requires_login
        $scope.checkIfLoggedIn()
        if $rootScope.member 
          getBookingAndSurvey()
        else
          return
      else
        getBookingAndSurvey()


  $scope.checkIfLoggedIn = () =>
    LoginService.checkLogin()


  $scope.loadSurvey = (purchase) =>
    unless $scope.company 
      $scope.purchase.$get('company').then (company) =>
        setPurchaseCompany(company)

    if $scope.purchase.$has('client')
      $scope.purchase.$get('client').then (client) =>
        $scope.setClient(new BBModel.Client(client))

    $scope.purchase.getBookingsPromise().then (bookings) =>
      params = {}
      $scope.bookings = bookings
      for booking in $scope.bookings
        if booking.datetime
          booking.pretty_date = moment(booking.datetime).format("dddd, MMMM Do YYYY")       
        if booking.address
          address = new BBModel.Address(booking.address)
          pretty_address = address.addressSingleLine()
          booking.pretty_address = pretty_address
        if $rootScope.user
          params.admin_only = true
        booking.$get("survey_questions", params).then (details) =>
          item_details = new BBModel.ItemDetails(details)
          booking.survey_questions = item_details.survey_questions
          booking.getSurveyAnswersPromise().then (answers) =>
            booking.survey_answers = answers
            for question in booking.survey_questions
              if booking.survey_answers
                for answer in booking.survey_answers
                  if (answer.question_text) == question.name && answer.value
                    question.answer = answer.value
            $scope.setLoaded $scope
    , (err) ->
      $scope.setLoaded $scope
      failMsg()
    

  $scope.submitSurveyLogin = (form) =>
    return if !ValidatorService.validateForm(form)
    LoginService.companyLogin($scope.company, {}, {email: $scope.login.email, password: $scope.login.password, id: $scope.company.id}).then (member) =>
      LoginService.setLogin(member)
      getBookingAndSurvey()
    , (err) -> 
      showLoginError()
      $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  
  $scope.loadSurveyFromPurchaseID = (id) =>
    params = {purchase_id: id, url_root: $scope.bb.api_url}
    auth_token = $sessionStorage.getItem('auth_token')
    params.auth_token = auth_token if auth_token
    PurchaseService.query(params).then (purchase) =>
      $scope.purchase = purchase
      $scope.total = $scope.purchase
      $scope.loadSurvey($scope.purchase)
    , (err) ->
      $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.loadSurveyFromBookingRef = (id) =>
    params = {booking_ref: id, url_root: $scope.bb.api_url, raw: true}
    auth_token = $sessionStorage.getItem('auth_token')
    params.auth_token = auth_token if auth_token
    PurchaseService.bookingRefQuery(params).then (purchase) =>
      $scope.purchase = purchase
      $scope.total = $scope.purchase
      $scope.loadSurvey($scope.purchase)
    , (err) ->
      showLoginError()
      $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.submitSurvey = (form) =>
    return if !ValidatorService.validateForm(form)
    for booking in $scope.bookings
      booking.checkReady()
      if booking.ready
        $scope.notLoaded $scope
        booking.client_id = $scope.client.id
        params = (booking)
        PurchaseBookingService.addSurveyAnswersToBooking(params).then (booking) ->
          $scope.setLoaded $scope
          $scope.completed = true
        , (err) ->
          $scope.setLoaded $scope
      else
        $scope.decideNextPage(route)
  

  $scope.submitBookingRef = (form) =>
    return if !ValidatorService.validateForm(form)
    $scope.notLoaded $scope
    params = {booking_ref: $scope.booking_ref, url_root: $scope.bb.api_url, raw: true}
    auth_token = $sessionStorage.getItem('auth_token')
    params.auth_token = auth_token if auth_token
    PurchaseService.bookingRefQuery(params).then (purchase) =>
      $scope.purchase = purchase
      $scope.total = $scope.purchase
      $scope.loadSurvey($scope.purchase)
    , (err) ->
      showLoginError()
      $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.storeBookingCookie = () ->
    document.cookie = "bookingrefsc=" + $scope.booking_ref

  showLoginError = () =>
    $scope.login_error = true


  getMember = () =>
    params = {member_id: $scope.member_id, company_id: $scope.company_id}
    LoginService.memberQuery(params).then (member) =>
      $scope.member = member


  setPurchaseCompany = (company) ->
    $scope.bb.company_id = company.id
    $scope.bb.company = new BBModel.Company(company)
    $scope.company = $scope.bb.company 
    $scope.bb.item_defaults.company = $scope.bb.company
    if company.settings
      $scope.bb.item_defaults.merge_resources = true if company.settings.merge_resources
      $scope.bb.item_defaults.merge_people    = true if company.settings.merge_people

  getBookingRef = () ->
    matches = /^.*(?:\?|&)booking_ref=(.*?)(?:&|$)/.exec($location.absUrl())
    booking_ref = matches[1] if matches
    booking_ref

  getPurchaseID = () ->
    matches = /^.*(?:\?|&)id=(.*?)(?:&|$)/.exec($location.absUrl())
    purchase_id = matches[1] if matches
    purchase_id

  getBookingAndSurvey = () ->
    id = getBookingRef()
    if id
      $scope.loadSurveyFromBookingRef(id)
    else
      id = getPurchaseID()
      if id
        $scope.loadSurveyFromPurchaseID(id)
      else
        if $scope.bb.total
          $scope.loadSurveyFromPurchaseID($scope.bb.total.long_id)
        else
          return

