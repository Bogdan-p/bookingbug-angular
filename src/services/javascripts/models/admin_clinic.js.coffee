'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.ClinicModel
*
* @description
* path: src/services/javascripts/models/admin_clinic.js.coffee
*
* Creates Admin_Clinic object.
*
* <pre>
* angular.module('BB.Models').factory "Admin.ClinicModel", ($q, BBModel, BaseModel) ->
*   class Admin_Clinic extends BaseModel
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
angular.module('BB.Models').factory "Admin.ClinicModel", ($q, BBModel, BaseModel) ->

  class Admin_Clinic extends BaseModel

    ###**
    * @ngdoc method
    * @name constructor
    * @methodOf BB.Models:Admin.ClinicModel
    *
    * @description
    * constructor
    *
    * @param {object} data data
    *
    * @returns {function} this.setResourcesAndPeople()
    *
    ###
    constructor: (data) ->
      super(data)
      @setTimes()
      @setResourcesAndPeople()

    ###**
    * @ngdoc method
    * @name setResourcesAndPeople
    * @methodOf BB.Models:Admin.ClinicModel
    *
    * @description
    * setResourcesAndPeople
    *
    ###
    setResourcesAndPeople: () ->
      @resources = _.reduce(@resource_ids, (h, id) ->
        h[id] = true
        h
      , {})
      @people = _.reduce(@person_ids, (h, id) ->
        h[id] = true
        h
      , {})
      @uncovered = !@person_ids || @person_ids.length == 0
      if @uncovered
        @className = "clinic_uncovered"
      else
        @className = "clinic_covered"

    ###**
    * @ngdoc method
    * @name setTimes
    * @methodOf BB.Models:Admin.ClinicModel
    *
    * @description
    * setTimes
    *
    ###
    setTimes: () ->
      if @start_time
        @start_time = moment(@start_time)
        @start = @start_time
      if @end_time
        @end_time = moment(@end_time)
        @end = @end_time
      @title = @name

    ###**
    * @ngdoc getPostData
    * @name setTimes
    * @methodOf BB.Models:Admin.ClinicModel
    *
    * @description
    * getPostData
    *
    * @returns {object} newly created data object
    *
    ###
    getPostData: () ->
      data = {}
      data.name = @name
      data.start_time = @start_time
      data.end_time = @end_time
      data.resource_ids = []
      for id, en of @resources
        data.resource_ids.push(id) if en
      data.person_ids = []
      for id, en of @people
        data.person_ids.push(id) if en
      console.log @address
      data.address_id = @address.id if @address
      data

    ###**
    * @ngdoc getPostData
    * @name save
    * @methodOf BB.Models:Admin.ClinicModel
    *
    * @description
    * save
    *
    * @returns {function} this.setResourcesAndPeople()
    *
    ###
    save: () ->
      @person_ids = _.compact(_.map(@people, (present, person_id) ->
        person_id if present
      ))
      @resource_ids = _.compact(_.map(@resources, (present, person_id) ->
        person_id if present
      ))
      @$put('self', {}, @).then (clinic) =>
        @updateModel(clinic)
        @setTimes()
        @setResourcesAndPeople()

