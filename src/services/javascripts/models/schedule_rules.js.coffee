'use strict'

###**
* @ngdoc object
* @name BB.Models:ScheduleRules
*
* @description
* This is ScheduleRules in BB.Models module that creates ScheduleRules object.
*
* <pre>
* //Creates class ScheduleRules
* class ScheduleRules
* </pre>
*
* @returns {object} Newly created ScheduleRules object with the following set of methods:
*
* - constructor(rules = {})
* - addRange(start, end)
* - removeRange(start, end)
* - addWeekdayRange(start, end)
* - removeWeekdayRange(start, end)
* - addRangeToDate(date, range)
* - removeRangeFromDate(date, range)
* - applyFunctionToDateRange(start, end, format, func)
* - diffInDays(start, end)
* - subtractRange(ranges, range)
* - joinRanges: (ranges)
* - filterRulesByDates()
* - filterRulesByWeekdays()
* - formatTime(time)
* - toEvents(d)
* - toWeekdayEvents()
*
###

angular.module('BB.Models').factory "ScheduleRules", () ->

  class ScheduleRules

     ###**
    * @ngdoc method
    * @name constructor
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * constructor
    *
    * @param {object} rules rules
    *
    ###

    constructor: (rules = {}) ->
      @rules = rules

    ###**
    * @ngdoc method
    * @name addRange
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * addRange
    *
    * @param {object} start start
    * @param {object} end end
    *
    ###

    addRange: (start, end) ->
      @applyFunctionToDateRange(start, end, 'YYYY-MM-DD', @addRangeToDate)

    ###**
    * @ngdoc method
    * @name removeRange
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * removeRange
    *
    * @param {object} start start
    * @param {object} end end
    *
    ###

    removeRange: (start, end) ->
      @applyFunctionToDateRange(start, end, 'YYYY-MM-DD', @removeRangeFromDate)

    ###**
    * @ngdoc method
    * @name addWeekdayRange
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * addWeekdayRange
    *
    * @param {object} start start
    * @param {object} end end
    *
    ###

    addWeekdayRange: (start, end) ->
      @applyFunctionToDateRange(start, end, 'd', @addRangeToDate)

    ###**
    * @ngdoc method
    * @name removeWeekdayRange
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * removeWeekdayRange
    *
    * @param {object} start start
    * @param {object} end end
    *
    ###

    removeWeekdayRange: (start, end) ->
      @applyFunctionToDateRange(start, end, 'd', @removeRangeFromDate)

    ###**
    * @ngdoc method
    * @name addRangeToDate
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * addRangeToDate
    *
    * @param {object} date date
    * @param {object} range range
    *
    ###

    addRangeToDate: (date, range) =>
      ranges = if @rules[date] then @rules[date].split(',') else []
      @rules[date] = @joinRanges(@insertRange(ranges, range))

    ###**
    * @ngdoc method
    * @name removeRangeFromDate
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * removeRangeFromDate
    *
    * @param {object} date date
    * @param {object} range range
    *
    * @returns {array} this.rules[date]
    ###

    removeRangeFromDate: (date, range) =>
      ranges = if @rules[date] then @rules[date].split(',') else []
      @rules[date] = @joinRanges(@subtractRange(ranges, range))
      delete @rules[date] if @rules[date] == ''

    ###**
    * @ngdoc method
    * @name applyFunctionToDateRange
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * applyFunctionToDateRange
    *
    * @param {object} start start
    * @param {object} end end
    * @param {object} format format
    * @param {object} func func
    *
    * @returns {object} this.rules
    ###

    applyFunctionToDateRange: (start, end, format, func) ->
      days = @diffInDays(start, end)
      if days == 0
        date = start.format(format)
        range = [start.format('HHmm'), end.format('HHmm')].join('-')
        func(date, range)
      else
        end_time = moment(start).endOf('day')
        @applyFunctionToDateRange(start, end_time, format, func)
        _.each([1..days], (i) =>
          date = moment(start).add(i, 'days')
          if i == days
            unless end.hour() == 0 && end.minute() == 0
              start_time = moment(end).startOf('day')
              @applyFunctionToDateRange(start_time, end, format, func)
          else
            start_time = moment(date).startOf('day')
            end_time = moment(date).endOf('day')
            @applyFunctionToDateRange(start_time, end_time, format, func)
        )
      @rules

    ###**
    * @ngdoc method
    * @name diffInDays
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * diffInDays
    *
    * @param {object} start start
    * @param {object} end end
    *
    * @returns {function} days()
    ###

    diffInDays: (start, end) ->
      moment.duration(end.diff(start)).days()

    ###**
    * @ngdoc method
    * @name insertRange
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * insertRange
    *
    * @param {object} ranges ranges
    * @param {object} range range
    *
    * @returns {object} ranges
    ###

    insertRange: (ranges, range) ->
      ranges.splice(_.sortedIndex(ranges, range), 0, range)
      ranges

    ###**
    * @ngdoc method
    * @name subtractRange
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * subtractRange
    *
    * @param {object} ranges ranges
    * @param {object} range range
    *
    * @returns {function}  _.without(ranges, range)
    ###

    subtractRange: (ranges, range) ->
      if _.indexOf(ranges, range, true) > -1
        _.without(ranges, range)
      else
        _.flatten(_.map(ranges, (r) ->
          if range.slice(0, 4) >= r.slice(0, 4) && range.slice(5, 9) <= r.slice(5, 9)
            if range.slice(0, 4) == r.slice(0, 4)
              [range.slice(5, 9), r.slice(5, 9)].join('-')
            else if range.slice(5, 9) == r.slice(5, 9)
              [r.slice(0, 4), range.slice(0, 4)].join('-')
            else
              [[r.slice(0, 4), range.slice(0, 4)].join('-'),
               [range.slice(5, 9), r.slice(5, 9)].join('-')]
          else
            r
        ))

    ###**
    * @ngdoc method
    * @name joinRanges
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * joinRanges
    *
    * @param {object} ranges ranges
    *
    * @returns {object} range
    ###    

    joinRanges: (ranges) ->
      _.reduce(ranges, (m, range) ->
        if m == ''
          range
        else if range.slice(0, 4) <= m.slice(m.length - 4, m.length)
          if range.slice(5, 9) >= m.slice(m.length - 4, m.length)
            m.slice(0, m.length - 4) + range.slice(5, 9)
          else
            m
        else
          [m,range].join()
      , "")

    ###**
    * @ngdoc method
    * @name filterRulesByDates
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * filterRulesByDates
    *
    ###  

    filterRulesByDates: () ->
      _.pick @rules, (value, key) ->
        key.match(/^\d{4}-\d{2}-\d{2}$/)

    ###**
    * @ngdoc method
    * @name filterRulesByWeekdays
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * filterRulesByWeekdays
    *
    ###  

    filterRulesByWeekdays: () ->
      _.pick @rules, (value, key) ->
        key.match(/^\d$/)

    ###**
    * @ngdoc method
    * @name formatTime
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * formatTime
    *
    * @params {array} time time
    *
    * @returns {array} time
    ###  
        
    formatTime: (time) ->
      [time[0..1],time[2..3]].join(':')

    ###**
    * @ngdoc method
    * @name toEvents
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * toEvents
    *
    * @params {object} d d
    *
    ###  

    toEvents: (d) ->
      if d
        _.map(@rules[d].split(','), (range) =>
          start: [d, @formatTime(range.split('-')[0])].join('T')
          end: [d, @formatTime(range.split('-')[1])].join('T')
        )
      else
        _.reduce(@filterRulesByDates(), (memo, ranges, date) =>
          memo.concat(_.map(ranges.split(','), (range) =>
            start: [date, @formatTime(range.split('-')[0])].join('T')
            end: [date, @formatTime(range.split('-')[1])].join('T')
          ))
        ,[])

    ###**
    * @ngdoc method
    * @name toWeekdayEvents
    * @methodOf BB.Models:ScheduleRules
    *
    * @description
    * toWeekdayEvents
    *
    ###  

    toWeekdayEvents: () ->
      _.reduce(@filterRulesByWeekdays(), (memo, ranges, day) =>
        date = moment().set('day', day).format('YYYY-MM-DD')
        memo.concat(_.map(ranges.split(','), (range) =>
          start: [date, @formatTime(range.split('-')[0])].join('T')
          end: [date, @formatTime(range.split('-')[1])].join('T')
        ))
      ,[])

