'use strict';

###**
* @ngdoc object
* @name BB.Models:Admin.PersonModel
*
* @description
* path: src/services/javascripts/models/person.js.coffee
*
* Creates Admin_Person object.
*
* <pre>
* angular.module('BB.Models').factory "Admin.PersonModel", ($q, BBModel, BaseModel, PersonModel) ->
*   class Admin_Person extends PersonModel
* </pre>
*
* ## Returns newly created Admin_Clinic object with the following set of methods:
* - constructor(data)
* - setResourcesAndPeople()
* - setTimes()
* - getPostData()
* - save()
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
*
###
angular.module('BB.Models').factory "Admin.PersonModel", ($q, BBModel, BaseModel, PersonModel) ->

  class Admin_Person extends PersonModel

    ###**
    * @ngdoc method
    * @name constructor
    * @methodOf BB.Models:Admin.PersonModel
    *
    * @description
    * constructor
    *
    * @param {object} data data
    *
    * @returns {function} this.setCurrentCustomer()
    *
    ###

    constructor: (data) ->
      super(data)
      unless @queuing_disabled
        @setCurrentCustomer()

    ###**
    * @ngdoc method
    * @name setCurrentCustomer
    * @methodOf BB.Models:Admin.PersonModel
    *
    * @description
    * setCurrentCustomer
    *
    * @returns {Promise} defeder.promise
    *
    ###

    setCurrentCustomer: () ->
      defer = $q.defer()
      if @$has('queuer')
        @$get('queuer').then (queuer) =>
          @serving = new BBModel.Admin.Queuer(queuer)
          defer.resolve(@serving)
        , (err) ->
          defer.reject(err)
      else
        defer.resolve()
      defer.promise

    ###**
    * @ngdoc method
    * @name setAttendance
    * @methodOf BB.Models:Admin.PersonModel
    *
    * @description
    * setCurrentCustomer
    *
    * @param {object} status status
    *
    * @returns {Promise} defeder.promise
    *
    ###

    setAttendance: (status) ->
      defer = $q.defer()
      @$put('attendance', {}, {status: status}).then  (p) =>
        @updateModel(p)
        defer.resolve(@)
      , (err) =>
        defer.reject(err)
      defer.promise

    ###**
    * @ngdoc method
    * @name finishServing
    * @methodOf BB.Models:Admin.PersonModel
    *
    * @description
    * finishServing
    *
    * @returns {Promise} defeder.promise
    *
    ###

    finishServing: () ->
      defer = $q.defer()
      if @$has('finish_serving')
        @$flush('self')
        @$post('finish_serving').then (q) =>
          @$get('self').then (p) => @updateModel(p)
          @serving = null
          defer.resolve(q)
        , (err) =>
          defer.reject(err)
      else
        defer.reject('finish_serving link not available')
      defer.promise

    ###**
    * @ngdoc method
    * @name isAvailable
    * @methodOf BB.Models:Admin.PersonModel
    *
    * @description
    * isAvailable
    *
    * @param {object} start start
    * @param {object} end end
    *
    * @returns {array} this.availability[str]
    *
    ###

    # look up a schedule for a time range to see if this available
    # currently just checks the date - but chould really check the time too
    isAvailable: (start, end) ->
      str = start.format("YYYY-MM-DD") + "-" + end.format("YYYY-MM-DD")
      @availability ||= {}

      return @availability[str] if @availability[str]
      @availability[str] = "-"

      if @$has('schedule')
        @$get('schedule', {start_date: start.format("YYYY-MM-DD"), end_date: end.format("YYYY-MM-DD")}).then (sched) =>
          @availability[str] = "No"
          if sched && sched.dates && sched.dates[start.format("YYYY-MM-DD")] && sched.dates[start.format("YYYY-MM-DD")] != "None"
            @availability[str] = "Yes"
      else
        @availability[str] = "Yes"

      return @availability[str]

    ###**
    * @ngdoc method
    * @name startServing
    * @methodOf BB.Models:Admin.PersonModel
    *
    * @description
    * startServing
    *
    * @param {object} queuer queuer
    *
    * @returns {Promise} defeder.promise
    *
    ###

    startServing: (queuer) ->
      defer = $q.defer()
      if @$has('start_serving')
        @$flush('self')
        params =
          queuer_id: if queuer then queuer.id else null
        @$post('start_serving', params).then (q) =>
          @$get('self').then (p) => @updateModel(p)
          @serving = q
          defer.resolve(q)
        , (err) =>
          defer.reject(err)
      else
        defer.reject('start_serving link not available')
      defer.promise

    ###**
    * @ngdoc method
    * @name getQueuers
    * @methodOf BB.Models:Admin.PersonModel
    *
    * @description
    * getQueuers
    *
    * @returns {Promise} defeder.promise
    *
    ###  

    getQueuers: () ->
      defer = $q.defer()
      if @$has('queuers')
        @$flush('queuers')
        @$get('queuers').then (collection) =>
          collection.$get('queuers').then (queuers) =>
            models = (new BBModel.Admin.Queuer(q) for q in queuers)
            @queuers = models
            defer.resolve(models)
          , (err) =>
            defer.reject(err)
        , (err) =>
          defer.reject(err)
      else
        defer.reject('queuers link not available')
      defer.promise

