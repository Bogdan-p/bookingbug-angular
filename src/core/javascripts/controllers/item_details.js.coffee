'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbItemDetails
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbItemDetails
*
* See Controller {@link BB.Controllers:ItemDetails ItemDetails}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'ItemDetails'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbItemDetails', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'ItemDetails'
  link : (scope, element, attrs) ->
    if attrs.bbItemDetails
      item = scope.$eval(attrs.bbItemDetails)
      scope.loadItem(item)
    return


###**
* @ngdoc controller
* @name BB.Controllers:ItemDetails
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller ItemDetails
*
* # Has the following set of methods:
*
* - $scope.loadItem(item)
* - setItemDetails(details)
* - $scope.recalc_price
* - $scope.confirm(form, route)
* - $scope.setReady()
* - $scope.confirm_move(route)
* - $scope.openTermsAndConditions()
* - $scope.getQuestion(id)
* - $scope.updateItem()
* - $scope.editItem()
* - $scope.onFileSelect(item, $file, existing)
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} $attrs Info
*
* @param {service} ItemDetailsService Info
* <br>
* {@link BB.Services:ItemDetailsService more}
*
* @param {service} PurchaseBookingService Info
* <br>
* {@link BB.Services:PurchaseBookingService more}
*
* @param {service} AlertService Info
* <br>
* {@link BB.Services:AlertService more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {service} FormDataStoreService Info
* <br>
* {@link BB.Services:FormDataStoreService more}
*
* @param {service} ValidatorService Info
* <br>
* {@link BB.Services:ValidatorService more}
*
* @param {service} QuestionService Info
* <br>
* {@link BB.Services:QuestionService more}
*
* @param {service} $modal is a service to quickly create AngularJS-powered modal windows. Creating custom modals is straightforward: create a partial view, its controller and reference them when using the service.
* <br>
* {@link https://github.com/angular-ui/bootstrap/tree/master/src/modal/docs more}
*
* @param {service} $location The $location service parses the URL in the browser address bar
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$location more}
*
* @param {service} $atuploadtrs Info
*
###
angular.module('BB.Controllers').controller 'ItemDetails', ($scope, $attrs, $rootScope, ItemDetailsService, PurchaseBookingService, AlertService, BBModel, FormDataStoreService, ValidatorService, QuestionService, $modal, $location, $upload) ->

  $scope.controller = "public.controllers.ItemDetails"

  $scope.suppress_basket_update = $attrs.bbSuppressBasketUpdate?
  $scope.item_details_id = $scope.$eval $attrs.bbSuppressBasketUpdate

  # if instructed to suppress basket updates (i.e. when the directive is invoked multiple times
  # on the same page), create a form store for each instance of the directive
  if $scope.suppress_basket_update
    FormDataStoreService.init ('ItemDetails'+$scope.item_details_id), $scope, ['item_details']
  else
    FormDataStoreService.init 'ItemDetails', $scope, ['item_details']

  # populate object with values stored in the question store. addAnswersByName()
  # is good for populating a single object. for dynamic question/answers see
  # addDynamicAnswersByName()
  QuestionService.addAnswersByName($scope.client, [
    'first_name'
    'last_name'
    'email'
    'mobile'
  ])

  $scope.notLoaded $scope
  $scope.validator = ValidatorService
  confirming = false


  $rootScope.connection_started.then () ->
    $scope.product = $scope.bb.current_item.product
    $scope.loadItem($scope.bb.current_item) if !confirming
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.loadItem = (item) ->
    confirming = true
    $scope.item = item
    $scope.item.private_note = $scope.bb.private_note if $scope.bb.private_note
    if $scope.item.item_details
      setItemDetails $scope.item.item_details
      # this will add any values in the querystring
      QuestionService.addDynamicAnswersByName($scope.item_details.questions)
      QuestionService.addAnswersFromDefaults($scope.item_details.questions, $scope.bb.item_defaults.answers) if $scope.bb.item_defaults.answers
      $scope.recalc_price()
      $scope.setLoaded $scope
    else
      params = {company: $scope.bb.company, cItem: $scope.item}
      ItemDetailsService.query(params).then (details) ->
        setItemDetails details
        $scope.item.item_details = $scope.item_details
        QuestionService.addDynamicAnswersByName($scope.item_details.questions)
        QuestionService.addAnswersFromDefaults($scope.item_details.questions, $scope.bb.item_defaults.answers) if $scope.bb.item_defaults.answers
        $scope.recalc_price()
        $scope.setLoaded $scope
      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  # compare the questions stored in the data store to the new questions and if
  # any of them match then copy the answer value. we're doing it like this as
  # the amount of questions can change based on selections made earlier in the
  # journey, so we can't just store the questions.
  setItemDetails = (details) ->
    if $scope.item && $scope.item.defaults
      _.each details.questions, (item) ->
        n = "q_" + item.name
        if $scope.item.defaults[n]
          item.answer = $scope.item.defaults[n]

    if $scope.hasOwnProperty 'item_details'
      oldQuestions = $scope.item_details.questions

      _.each details.questions, (item) ->
        search = _.findWhere(oldQuestions, { name: item.name })
        if search
          item.answer = search.answer

    $scope.item_details = details


  $scope.recalc_price = ->
    qprice = $scope.item_details.questionPrice($scope.item.getQty())
    bprice = $scope.item.base_price
    $scope.item.setPrice(qprice + bprice)


  $scope.confirm = (form, route) ->
    return if !ValidatorService.validateForm(form)
    # we need to validate the question information has been correctly entered here
    if $scope.bb.moving_booking
      return $scope.confirm_move(form, route)

    $scope.item.setAskedQuestions()
    if $scope.item.ready
      $scope.notLoaded $scope
      $scope.addItemToBasket().then () ->
        $scope.setLoaded $scope
        $scope.decideNextPage(route)
      , (err) ->
        $scope.setLoaded $scope
    else
      $scope.decideNextPage(route)


  $scope.setReady = () =>
    $scope.item.setAskedQuestions()
    if $scope.item.ready and !$scope.suppress_basket_update
      return $scope.addItemToBasket()
    else
      return true


  $scope.confirm_move = (route) ->
    confirming = true
    $scope.item ||= $scope.bb.current_item
    # we need to validate the question information has been correctly entered here
    $scope.item.setAskedQuestions()
    if $scope.item.ready
      $scope.notLoaded $scope
      PurchaseBookingService.update($scope.item).then (booking) ->
        b = new BBModel.Purchase.Booking(booking)

        if $scope.bb.purchase
          for oldb, _i in $scope.bb.purchase.bookings
            $scope.bb.purchase.bookings[_i] = b if oldb.id == b.id

        $scope.setLoaded $scope
        $scope.item.move_done = true
        $rootScope.$broadcast "booking:moved"
        $scope.decideNextPage(route)
        AlertService.add("info", { msg: "Your booking has been moved to #{b.datetime.format('dddd Do MMMM [at] h.mma')}" })
       , (err) =>
        $scope.setLoaded $scope
        AlertService.add("danger", { msg: "Failed to move booking. Please try again." })
    else
      $scope.decideNextPage(route)


  $scope.openTermsAndConditions = () ->
    modalInstance = $modal.open(
      templateUrl: $scope.getPartial "terms_and_conditions"
      scope: $scope
    )


  $scope.getQuestion = (id) ->
    for question in $scope.item_details.questions
      return question if question.id == id

    return null


  $scope.updateItem = () ->
    $scope.item.setAskedQuestions()
    if $scope.item.ready
      $scope.notLoaded $scope

      PurchaseBookingService.update($scope.item).then (booking) ->

        b = new BBModel.Purchase.Booking(booking)
        if $scope.bookings
          for oldb, _i in $scope.bookings
            if oldb.id == b.id
              $scope.bookings[_i] = b

        $scope.purchase.bookings = $scope.bookings
        $scope.item_details_updated = true
        $scope.setLoaded $scope

       , (err) =>
        $scope.setLoaded $scope


  $scope.editItem = () ->
    $scope.item_details_updated = false


  $scope.onFileSelect = (item, $file, existing) ->
    $scope.upload_progress = 0
    file = $file
    att_id = null
    att_id = existing if existing
    method = "POST"
    method = "PUT" if att_id
    url = item.$href('add_attachment')
    $scope.upload = $upload.upload({
      url: url,
      method: method,
      data: {attachment_id: att_id},
      file: file,
    }).progress (evt) ->
      if $scope.upload_progress < 100
        $scope.upload_progress = parseInt(99.0 * evt.loaded / evt.total)
    .success (data, status, headers, config) ->
      $scope.upload_progress = 100
      if data && item
        item.attachment = data
        item.attachment_id = data.id
