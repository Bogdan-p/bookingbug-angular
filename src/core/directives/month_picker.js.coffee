


angular.module('BB.Directives').directive 'bbMonthPicker', ($rootScope, FormDataStoreService) ->
  restrict: 'AE'
  replace: true
  scope : true
  link : (scope, el, attrs) ->

    scope.picker_settings = scope.$eval( attrs.bbMonthPicker )

    scope.num_months = scope.picker_settings.months or 3

    scope.watch_val = attrs.dayData

    scope.$watch scope.watch_val, (newval, oldval) ->
      if newval
        scope.processDates(newval)

  controller : ($scope,  $rootScope,  $q) ->

#    FormDataStoreService.init 'bbMonthPicker', $scope, [
#      'selected_month'
#    ]

    $scope.processDates = (dates) ->
      datehash = {}
      for date in dates
        datehash[date.date.format("DDMMYY")] = date
        $scope.first_available_day = date.date if !$scope.first_available_day and date.spaces > 0

      if $scope.picker_settings.start_at_first_available_day
        cur_month = $scope.first_available_day.clone().startOf('month')
      else
        cur_month = dates[0].date.clone().startOf('month')

      date = cur_month.startOf('week')

      months = []
      for m in [1..$scope.num_months]
        date = cur_month.clone().startOf('week')
        month = {weeks: []}
        for w in [1..6]
          week = {days: []}
          for d in [1..7]
            week.days.push({date: date.clone(), data: datehash[date.format("DDMMYY")] })

            if date.isSame(date.clone().startOf('month'),'day') and !month.start_date
              month.start_date = date.clone()

            date.add(1, 'day')
            
          month.weeks.push(week)

        months.push(month)
        cur_month.add(1, 'month')

      $scope.months = months

      if $scope.selected_date?
        $scope.selectMonthNumber($scope.selected_date.month())
      $scope.selected_month = $scope.selected_month or $scope.months[0]


    $scope.selectMonth = (month) ->
      $scope.selected_month = month

      # select the first day in the month that has some events
      for week in month.weeks
        for day in week.days
          if (day.data && day.data.spaces > 0) and (day.date.isSame(month.start_date, 'day') or day.date.isAfter(month.start_date, 'day'))
            $scope.showDate(day.date) 
            return

    $scope.selectMonthNumber = (month) ->
      return if $scope.selected_month && $scope.selected_month.start_date.month() == month

      for m in $scope.months
        $scope.selectMonth(m) if m.start_date.month() == month
      true


    $scope.add = (value) ->
      for month, index in $scope.months
        if $scope.selected_month is month and $scope.months[index + value]
          $scope.selectMonth($scope.months[index + value])
          return true

      return false


    $scope.subtract = (value) ->
      $scope.add(-value)