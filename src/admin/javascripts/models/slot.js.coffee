'use strict';

###**
* @ngdoc object
* @name BB.Models:Admin.SlotModel
*
* @description
* This is SlotModel for Admin in BB.Models module that creates Admin_Slot object.
*
* <pre>
* //Creates class Admin_Slot that extends TimeSlotModel
* class Admin_Slot extends TimeSlotModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
*
* @param {model} TimeSlotModel Info
*
* @returns {object} Newly created Admin_Slot object.
*
###
angular.module('BB.Models').factory "Admin.SlotModel", ($q, BBModel, BaseModel, TimeSlotModel) ->

  class Admin_Slot extends TimeSlotModel

    ###**
    * @ngdoc method
    * @name constructor
    * @methodOf BB.Models:Admin.SlotModel
    *
    * @description
    * Method constructor. Creates Admin_Slot object with following properties
    *
    * - title
    * - status
    * - datetime
    * - title
    * - start
    * - end
    * - time
    * - allDay
    * - className
    *
    * <pre>
    * if @status == 3 @className = "status_blocked"
    * else if @status == 4  @className = "status_booked"
    * else if @status == 0 @className = "status_available"
    * </pre>
    *
    * @param {object} data Info
    ###
    constructor: (data) ->
      super(data)
      @title = @full_describe
      if @status == 0
        @title = "Available"
      @datetime = moment(@datetime)
      @start = @datetime
      @end = @datetime.clone().add(@duration, 'minutes')
      @time = @start.hour()* 60 + @start.minute()
      @allDay = false
      if @status == 3
        @className = "status_blocked"
      else if @status == 4
        @className = "status_booked"
      else if @status == 0
        @className = "status_available"
