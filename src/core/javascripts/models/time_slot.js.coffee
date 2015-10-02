'use strict';

###**
* @ngdoc object
* @name BB.Models:TimeSlotModel
*
* @description
* This is TimeSlotModel in BB.Models module that creates TimeSlot object.
*
* <pre>
* //Creates class TimeSlot that extends BaseModel
* class TimeSlot extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* * <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @returns {object} Newly created TimeSlot object with the following set of methods:
*
* - constructor(data, service)
* - print_time
* - print_end_time(dur)
* - print_time12(show_suffix = true)
* - print_end_time12(show_suffix = true, dur)
* - availability
* - select
* - disable(reason)
* - enable
* - status
*
###
angular.module('BB.Models').factory "TimeSlotModel", ($q, $window, BBModel, BaseModel) ->

  class TimeSlot extends BaseModel

    constructor: (data, service) ->
      super(data)
      @service = service
      @time_12 = @print_time12()
      @time_24 = @print_time()


    # 24 hour time
    print_time: ->
      if @start
        @start.format("h:mm")
      else
        t = @get('time')
        if t%60 < 10
          min = "0" + t%60
        else
          min = t%60
        "" + Math.floor(t / 60) + ":" + min


    # 24 hour time
    print_end_time: (dur) ->
      if @end
        @end.format("h:mm")
      else
        dur = @service.listed_durations[0] if !dur
        t = @get('time') + dur

        if t%60 < 10
          min = "0" + t%60
        else
          min = t%60
        "" + Math.floor(t / 60) + ":" + min

    # 12 hour time
    print_time12: (show_suffix = true) ->
      t = @get('time')
      h = Math.floor(t / 60)
      m = t%60
      suffix = 'am'
      suffix = 'pm' if h >=12
      h -=12 if (h > 12)
      time = $window.sprintf("%d.%02d", h, m)
      time += suffix if show_suffix
      return time

    # 12 hour time
    print_end_time12: (show_suffix = true, dur) ->
      dur = null
      if !dur
        if @service.listed_duration?
          dur = @service.listed_duration
        else
          dur = @service.listed_durations[0]
      t = @get('time') + dur
      h = Math.floor(t / 60)
      m = t%60
      suffix = 'am'
      suffix = 'pm' if h >=12
      h -=12 if (h > 12)
      end_time = $window.sprintf("%d.%02d", h, m)
      end_time += suffix if show_suffix
      return end_time

    availability: ->
      @avail

    select: ->
      @selected = true

    unselect: ->
      delete @selected if @selected

    disable: (reason)->
      @disabled = true
      @disabled_reason = reason

    enable: ->
      delete @disabled if @disabled
      delete @disabled_reason if @disabled_reason


    status: ->
      return "selected" if @selected
      return "disabled" if @disabled
      return "enabled" if @availability() > 0
      return "disabled"
