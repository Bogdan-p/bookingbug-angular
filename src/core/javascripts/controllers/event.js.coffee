'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbEvent
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbEvent
*
* See Controller {@link BB.Controllers:Event Event}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'Event'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbEvent', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Event'

###**
* @ngdoc controller
* @name BB.Controllers:Event
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller Event
*
* # Has the following set of methods:
*
* - $scope.init(comp)
* - $scope.selectTickets()
* - $scope.selectItem(item, route)
* - $scope.setReady()
* - $scope.getPrePaidsForEvent(client, event)
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} PageControllerService Info
* <br>
* {@link BB.Services:PageControllerService more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $attrs Info
*
* @param {service} EventService Info
* <br>
* {@link BB.Services:EventService more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {service} ValidatorService Info
* <br>
* {@link BB.Services:ValidatorService more}
*
###
angular.module('BB.Controllers').controller 'Event', ($scope, $attrs, $rootScope, EventService, $q, PageControllerService, BBModel, ValidatorService) ->
  $scope.controller = "public.controllers.Event"
  $scope.notLoaded $scope
  angular.extend(this, new PageControllerService($scope, $q))

  $scope.validator = ValidatorService
  $scope.event_options = $scope.$eval($attrs.bbEvent) or {}

  $rootScope.connection_started.then ->
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.init = (comp) ->
    $scope.event = $scope.bb.current_item.event
    promises = [$scope.current_item.event_group.getImagesPromise(), $scope.event.prepEvent()]
    if $scope.client
      promises.push $scope.getPrePaidsForEvent($scope.client, $scope.event)

    $q.all(promises).then (result) ->
      if result[0] and result[0].length > 0
        image = result[0][0]
        image.background_css = {'background-image': 'url(' + image.url + ')'}
        $scope.event.image = image
        # TODO pick most promiment image
        # colorThief = new ColorThief()
        # colorThief.getColor image.url


      for ticket in $scope.event.tickets
        ticket.qty = if $scope.event_options.default_num_tickets then $scope.event_options.default_num_tickets else 0

      $scope.selectTickets() if $scope.event_options.default_num_tickets and $scope.event_options.auto_select_tickets and $scope.event.tickets.length is 1

      $scope.tickets = $scope.event.tickets
      $scope.bb.basket.total_price = $scope.bb.basket.totalPrice()
      $scope.stopTicketWatch = $scope.$watch 'tickets', (tickets, oldtickets) ->
        $scope.bb.basket.total_price = $scope.bb.basket.totalPrice()
        $scope.event.updatePrice()
      , true
      $scope.setLoaded $scope

    , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.selectTickets = () ->
    # process the selected tickets - this may mean adding multiple basket items - add them all to the basket
    $scope.notLoaded $scope
    $scope.bb.emptyStackedItems()
    #$scope.setBasket(new BBModel.Basket(null, $scope.bb)) # we might already have a basket!!
    base_item = $scope.current_item
    for ticket in $scope.event.tickets
      if ticket.qty
        switch ($scope.event.chain.ticket_type)
          when "single_space"
            for c in [1..ticket.qty]
              item = new BBModel.BasketItem()
              angular.extend(item, base_item)
              item.tickets = angular.copy(ticket)
              item.tickets.qty = 1
              $scope.bb.stackItem(item)
          when "multi_space"
            item = new BBModel.BasketItem()
            angular.extend(item, base_item)
            item.tickets = angular.copy(ticket)
            item.tickets.qty = ticket.qty
            $scope.bb.stackItem(item)
    # ok so we have them as stacked items
    # now push the stacked items to a basket
    if $scope.bb.stacked_items.length == 0
      $scope.setLoaded $scope
      return

    $scope.bb.pushStackToBasket()
    $scope.updateBasket().then () =>
      # basket has been saved
      $scope.setLoaded $scope
      $scope.selected_tickets = true
      $scope.stopTicketWatch()
      $scope.tickets = (item.tickets for item in $scope.bb.basket.items)
      $scope.$watch 'bb.basket.items', (items, olditems) ->
        $scope.bb.basket.total_price = $scope.bb.basket.totalPrice()
        item.tickets.price = item.totalPrice()
      , true
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.selectItem = (item, route) =>
    if $scope.$parent.$has_page_control
      $scope.event = item
      return false
    else
      $scope.bb.current_item.setEvent(item)
      $scope.bb.current_item.ready = false
      $scope.decideNextPage(route)
      return true


  $scope.setReady = () =>
    $scope.bb.event_details = {
      name         : $scope.event.chain.name,
      image        : $scope.event.image,
      address      : $scope.event.chain.address,
      datetime     : $scope.event.date,
      end_datetime : $scope.event.end_datetime,
      duration     : $scope.event.duration
      tickets      : $scope.event.tickets
    }

    return $scope.updateBasket()

  $scope.getPrePaidsForEvent = (client, event) ->
    defer = $q.defer()
    params = {event_id: event.id}
    client.getPrePaidBookingsPromise(params).then (prepaids) ->
      $scope.pre_paid_bookings = prepaids
      defer.resolve(prepaids)
    , (err) ->
      defer.reject(err)
    defer.promise

