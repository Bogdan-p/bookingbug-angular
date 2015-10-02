'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.BookingModel
*
* @description
* <br> ---------------------------------------------------------------------------------
* <br> NOTE
* <br> This is the TEST file.
* <br> Formatting of the documentation for this kind of functionality should be done first here
* <br> !To avoid repetition and to mentain consistency.
* <br> After the documentation for TEST file it is defined other files that have the same pattern can be also documented
* <br> This should be the file that sets the STANDARD.
* <br> ---------------------------------------------------------------------------------<br><br>
* This is BookingModel for Admin in BB.Models module that creates Admin_Booking object.
*
* <pre>
* //Creates class Admin_booking that extends BaseModel
* class Admin_Booking extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* * <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
*
*
* @returns {object} Newly created Admin_Booking object with the following set of methods:
*
* - constructor(data)
* - getPostData()
* - statusTime()
* - hasStatus(status)
* - statusTime(status)
* - sinceStatus(status)
* - sinceStart(options)
* - $update(data)
*
###
angular.module('BB.Models').factory "Admin.BookingModel", ($q, BBModel, BaseModel) ->

  class Admin_Booking extends BaseModel

    ###**
    * @ngdoc method
    * @name constructor
    * @methodOf BB.Models:Admin.BookingModel
    *
    * @description
    * Method constructor. Creates Admin_Booking object with following properties
    *
    * - datetime
    * - start
    * - end
    * - title
    * - time
    * - allDay
    * - className
    *
    * <pre>
    * if @status == 3 @className = "status_blocked"
    * else if @status == 4 @className = "status_booked"
    * </pre>
    *
    * @param {object} data Info
    ###
    constructor: (data) ->
      super
      @datetime = moment(@datetime)
      @start = @datetime
      @end = @datetime.clone().add(@duration, 'minutes')
      @title = @full_describe
      @time = @start.hour()* 60 + @start.minute()
      @allDay = false
      if @status == 3
        @className = "status_blocked"
      else if @status == 4
        @className = "status_booked"

    ###**
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:Admin.BookingModel
    *
    * @description
    * Method getPostData. This method is added to Admin_Booking Object prototype. It returns the data object.
    *
    * data object is created with the following properties
    *
    * - date
    * - time
    * - duration
    * - id
    * - person_id
    *
    * if question == true it will be created an array called results
    *
    * <pre>
    * data.questions = (q.getPostData() for q in @questions)
    * </pre>
    *
    * @returns {object} data
    ###
    getPostData: () ->
      data = {}
      data.date = @start.format("YYYY-MM-DD")
      data.time = @start.hour() * 60 + @start.minute()
      data.duration = @duration
      data.id = @id
      data.person_id = @person_id
      if @questions
        data.questions = (q.getPostData() for q in @questions)
      data

    ###**
    * @ngdoc method
    * @name hasStatus
    * @methodOf BB.Models:Admin.BookingModel
    *
    * @description
    * Method hasStatus. This method is added to Admin_Booking Object prototype.
    *
    * @param {object} status Info
    *
    * @returns {object} multi_status[status]
    *
    ###
    hasStatus: (status) ->
      @multi_status[status]?

    ###**
    * @ngdoc method
    * @name statusTime
    * @methodOf BB.Models:Admin.BookingModel
    *
    * @description
    * Method statusTime. This method is added to Admin_Booking Object prototype.
    *
    * @param {object} status Info
    *
    * @returns {date} null or new date based on multi_status[status] if multi_status[status] is true
    ###
    statusTime: (status) ->
      if @multi_status[status]
        moment(@multi_status[status])
      else
        null

    ###**
    * @ngdoc method
    * @name sinceStatus
    * @methodOf BB.Models:Admin.BookingModel
    *
    * @description
    * Method sinceStatus. This method is added to Admin_Booking Object prototype.
    *
    * @param {object} status Info
    *
    * @returns {Number} Math.floor()
    ###
    sinceStatus: (status) ->
      s = @statusTime(status)
      return 0 if !s
      return Math.floor((moment().unix() - s.unix()) / 60)

    ###**
    * @ngdoc method
    * @name sinceStart
    * @methodOf BB.Models:Admin.BookingModel
    *
    * @description
    * Method sinceStart. This method is added to Admin_Booking Object prototype.
    *
    * @param {object} options Info
    *
    * @returns {Number} Math.floor()
    ###
    sinceStart: (options) ->
      start = @datetime.unix()
      if !options
        return Math.floor((moment().unix() - start) / 60)
      if options.later
        s = @statusTime(options.later).unix()
        if s > start
          return Math.floor((moment().unix() - s) / 60)
      if options.earlier
        s = @statusTime(options.earlier).unix()
        if s < start
          return Math.floor((moment().unix() - s) / 60)
      return Math.floor((moment().unix() - start) / 60)

    ###**
    * @ngdoc method
    * @name $update
    * @methodOf BB.Models:Admin.BookingModel
    *
    * @description
    * Method $update. This method is added to Admin_Booking Object prototype.
    *
    * @param {object} data Info
    *
    * @returns {object} Admin_Booking
    ###
    $update: (data) ->
      data ||= @getPostData()
      @$put('self', {}, data).then (res) =>
        @constructor(res)
