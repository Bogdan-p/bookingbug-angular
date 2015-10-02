'use strict';

###**
* @ngdoc directive
* @name BB.Directives:bbMonthAvailability
* @restrict AE
* @scope true
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}

* Directive BB.Directives:bbMonthAvailability
*
* See Controller {@link BB.Controllers:DayList DayList}
*
* <pre>
* restrict: 'AE'
* replace: true
* scope : true
* controller : 'DayList'
* </pre>
*
###
angular.module('BB.Directives').directive 'bbMonthAvailability', () ->
  restrict: 'A'
  replace: true
  scope : true
  controller : 'DayList'

###**
* @ngdoc controller
* @name BB.Controllers:DayList
*
* @description
* {@link https://docs.angularjs.org/guide/controller more about Controllers}
*
* Controller DayList
*
* # Has the following set of methods:
*
* - $scope.setCalType(type)
* - $scope.setDataSource(source)
* - $scope.format_date(fmt)
* - $scope.format_start_date(fmt)
* - $scope.format_end_date(fmt)
* - $scope.selectDay(day, route, force)
* - $scope.setMonth(month, year)
* - $scope.setWeek(week, year)
* - $scope.add(type, amount)
* - $scope.subtract(type, amount)
* - $scope.isPast()
* - $scope.loadData
* - $scope.loadMonth
* - $scope.loadWeek
* - $scope.setReady
*
* @param {service} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} DayService Info
* <br>
* {@link BB.Services:DayService more}
*
* @param {service} AlertService Info
* <br>
* {@link BB.Services:AlertService more}
*
###
angular.module('BB.Controllers').controller 'DayList', ($scope,  $rootScope, $q, DayService, AlertService) ->
  $scope.controller = "public.controllers.DayList"
  $scope.notLoaded $scope


  $scope.WeekHeaders = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
  $scope.day_data = {}
  if !$scope.type
    $scope.type = "month"
  if !$scope.data_source
    $scope.data_source = $scope.bb.current_item

  # Load up some day based data
  $rootScope.connection_started.then =>
    if !$scope.current_date && $scope.last_selected_date
      $scope.current_date = $scope.last_selected_date.startOf($scope.type)
    else if !$scope.current_date
      $scope.current_date = moment().startOf($scope.type)
    $scope.loadData()
  , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  $scope.$on "currentItemUpdate", (event) ->
    $scope.loadData()

  $scope.setCalType = (type) =>
    $scope.type = type

  $scope.setDataSource = (source) =>
    $scope.data_source = source

  $scope.format_date = (fmt) =>
    if $scope.current_date
      $scope.current_date.format(fmt)

  $scope.format_start_date = (fmt) =>
    $scope.format_date(fmt)

  $scope.format_end_date = (fmt) =>
    if $scope.end_date
      $scope.end_date.format(fmt)

  $scope.selectDay = (day, route, force) =>
    if day.spaces == 0 && !force
      return false
    $scope.setLastSelectedDate(day.date)
    $scope.bb.current_item.setDate(day)
    if $scope.$parent.$has_page_control
      return
    else
      $scope.decideNextPage(route)

  $scope.setMonth = (month, year) =>
    $scope.current_date = moment().startOf('month').year(year).month(month-1)
    $scope.current_date.year()
    $scope.type = "month"

  $scope.setWeek = (week, year) =>
    $scope.current_date = moment().year(year).isoWeek(week).startOf('week')
    $scope.current_date.year()
    $scope.type = "week"

  $scope.add = (type, amount) =>
    $scope.current_date.add(amount, type)
    $scope.loadData()

  $scope.subtract = (type, amount) =>
    $scope.add(type, -amount)

  # calculate if the current earlist date is in the past - in which case we might want to disable going backwards
  $scope.isPast = () =>
    return true if !$scope.current_date
    return moment().isAfter($scope.current_date)

  $scope.loadData =  =>
    if $scope.type == "week"
      $scope.loadWeek()
    else
      $scope.loadMonth()

  $scope.loadMonth =  =>
    date = $scope.current_date

    $scope.month = date.month()
    $scope.notLoaded $scope
    edate = moment(date).add(1, 'months')
    $scope.end_date = moment(edate).add(-1, 'days')

    if $scope.data_source
      DayService.query({company: $scope.bb.company, cItem: $scope.data_source, 'month':date.format("MMYY"), client: $scope.client }).then (days) =>
        $scope.days = days
        for day in days
          $scope.day_data[day.string_date] = day
        weeks = []
        for w in [0..5]
          week = []
          for d in [0..6]
            week.push(days[w*7+d])
          weeks.push(week)
        $scope.weeks = weeks
        $scope.setLoaded $scope
      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
    else
      $scope.setLoaded $scope

  $scope.loadWeek = =>
    date = $scope.current_date
    $scope.notLoaded $scope

    edate = moment(date).add(7, 'days')
    $scope.end_date = moment(edate).add(-1, 'days')
    if $scope.data_source
      DayService.query({company: $scope.bb.company, cItem: $scope.data_source, date: date.toISODate(), edate: edate.toISODate(), client: $scope.client  }).then (days) =>
        $scope.days = days
        for day in days
          $scope.day_data[day.string_date] = day
        $scope.setLoaded $scope
      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
    else
      $scope.setLoaded $scope

  $scope.setReady = () =>
    if $scope.bb.current_item.date
      return true
    else
      AlertService.clear()
      AlertService.add("danger", { msg: "You need to select a date" })
      return false

