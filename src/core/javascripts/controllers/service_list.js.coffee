'use strict';

angular.module('BB.Directives').directive 'bbServices', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'ServiceList'
  link : (scope, element, attrs) ->

    scope.options = scope.$eval(attrs.bbServices) or {}

    if attrs.bbItem
      scope.booking_item = scope.$eval( attrs.bbItem )
    if attrs.bbShowAll or scope.options.show_all 
      scope.show_all = true
    if scope.options.allow_single_pick
      scope.allowSinglePick = true
    return


angular.module('BB.Controllers').controller 'ServiceList',($scope,  $rootScope, $q, $attrs, $modal, $sce, ItemService, FormDataStoreService, ValidatorService, PageControllerService, halClient, AlertService, ErrorService, $filter, CategoryService) ->

  $scope.controller = "public.controllers.ServiceList"
  FormDataStoreService.init 'ServiceList', $scope, [
    'service'
  ]
  $scope.notLoaded $scope
  angular.extend(this, new PageControllerService($scope, $q))

  $scope.validator = ValidatorService

  $scope.filters = {price: {}, name: null}

  $rootScope.connection_started.then () =>
    if $scope.bb.company
      $scope.init($scope.bb.company)
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.init = (comp) ->
    $scope.booking_item ||= $scope.bb.current_item

    if $scope.bb.company.$has('named_categories')
      CategoryService.query($scope.bb.company).then (items) =>
        $scope.all_categories = items
      , (err) ->  $scope.all_categories = []
    else
      $scope.all_categories = []

    # check any curretn service is valid for the current company
    if $scope.service && $scope.service.company_id != $scope.bb.company.id
      $scope.service = null

    ppromise = comp.getServicesPromise()
    @skipped = false
    ppromise.then (items) =>
      # not all service lists need filtering. check for attribute first
      filterItems = if $attrs.filterServices is 'false' then false else true

      if filterItems
        if $scope.booking_item.service_ref && !$scope.show_all
          items = items.filter (x) -> x.api_ref is $scope.booking_item.service_ref
        else if $scope.booking_item.category && !$scope.show_all
          # if we've selected a category for the current item - limit the list
          # of services to ones that are relevant
          items = items.filter (x) -> x.$has('category') && x.$href('category') is $scope.booking_item.category.self

      # filter out event groups unless explicity requested
      if !$scope.options.show_event_groups
        items = items.filter (x) -> !x.is_event_group 

      if (items.length is 1 && !$scope.allowSinglePick)
        if !$scope.selectItem(items[0], $scope.nextRoute )
          setServiceItem items
        else if !@skipped
          $scope.skipThisStep()
          @skipped = true          
      else
        setServiceItem items

      # if there's a default - pick it and move on
      if $scope.booking_item.defaultService()
        for item in items
          if item.self == $scope.booking_item.defaultService().self or (item.name is $scope.booking_item.defaultService().name and !item.deleted)
            $scope.selectItem(item, $scope.nextRoute)

      # if there's one selected - just select it
      if $scope.booking_item.service
        for item in items
          item.selected = false
          if item.self is $scope.booking_item.service.self
            $scope.service = item
            item.selected = true
            $scope.booking_item.setService($scope.service)

      $scope.setLoaded $scope

      if $scope.booking_item.service || !(($scope.booking_item.person && !$scope.booking_item.anyPerson()) || ($scope.booking_item.resource && !$scope.booking_item.anyResource()))
        # the "bookable services" are the service unless we've pre-selected something!
        $scope.bookable_services = $scope.items
    , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

    if ($scope.booking_item.person && !$scope.booking_item.anyPerson()) ||
       ($scope.booking_item.resource && !$scope.booking_item.anyResource())

      # if we've lready picked a service or a resource - get a more limited service selection
      ItemService.query({company: $scope.bb.company, cItem: $scope.booking_item, wait: ppromise, item: 'service'}).then (items) =>
        if $scope.booking_item.service_ref
          items = items.filter (x) -> x.api_ref == $scope.booking_item.service_ref
        if $scope.booking_item.group
          items = items.filter (x) -> !x.group_id || x.group_id == $scope.booking_item.group
        services = (i.item for i in items when i.item?)
        
        $scope.bookable_services = services
        $scope.bookable_items = items
        
        if (services.length == 1 && !$scope.allowSinglePick)
          if !$scope.selectItem(services[0], $scope.nextRoute )
            setServiceItem services
          else if !@skipped
            $scope.skipThisStep()
            @skipped = true  
        else
          setServiceItem items
        
        $scope.setLoaded($scope)
      , (err) ->  
        $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
  
  # set the service item so the correct item is displayed in the dropdown menu.
  # without doing this the menu will default to 'please select'
  setServiceItem = (items) ->
    $scope.items = items
    $scope.filtered_items = $scope.items
    $scope.items_free = 0
    for item in $scope.items
      $scope.items_free = $scope.items_free + item.price
    if $scope.items_free != 0
      $scope.some_free = true
    if $scope.service
        _.each items, (item) ->
          if item.id is $scope.service.id
            $scope.service = item

  $scope.selectItem = (item, route) =>
    if $scope.routed
      return true

    if $scope.$parent.$has_page_control
      $scope.service = item
      return false
    else if item.is_event_group
      $scope.booking_item.setEventGroup(item)
      $scope.decideNextPage(route)
      $scope.routed = true
    else
      $scope.booking_item.setService(item)
      $scope.decideNextPage(route)
      $scope.routed = true
      return true

  $scope.$watch 'service', (newval, oldval) =>
    if $scope.service && $scope.booking_item
      if !$scope.booking_item.service or $scope.booking_item.service.self isnt $scope.service.self
        # only set and broadcast if it's changed
        $scope.booking_item.setService($scope.service)
        $scope.broadcastItemUpdate()


  $scope.setReady = () =>
    if $scope.service
      $scope.booking_item.setService($scope.service)
      return true
    else if $scope.bb.stacked_items and $scope.bb.stacked_items.length > 0
      return true
    else
      return false

  $scope.errorModal = () ->
    error_modal = $modal.open
      templateUrl: $scope.getPartial('error_modal')
      controller: ($scope, $modalInstance) ->
        $scope.message = ErrorService.getError('GENERIC').msg
        $scope.ok = () ->
          $modalInstance.close()

  $scope.filterFunction = (service) ->
    if !service
      return false
    else
      return (!$scope.filters.name or service.category_id is $scope.filters.name.id) and (!service.price or
        (service.price >= $scope.filters.price.min and service.price <= $scope.filters.price.max ))

  $scope.resetFilters = () ->
    $scope.filters.name = null
    $scope.filters.price.min = null
    $scope.filters.price.max = null
    $scope.filterChanged()

  $scope.filterChanged = () ->
    $scope.filtered_items = $filter('filter')($scope.items, $scope.filterFunction);

