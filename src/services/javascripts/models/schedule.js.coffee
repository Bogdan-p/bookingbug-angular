'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.ScheduleModel
*
* @description
* This is Admin.ScheduleModel in BB.Model module that creates Admin Resource Model object.
*
* <pre>
*  //Creates class Admin_Schedule that extends BaseModel
*   class Admin_Schedule extends BaseModel
* </pre>
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
*
* @returns {object} Newly created Admin.ScheduleModel object with the following set of methods:
*
* - constructor(data)
*
###

angular.module('BB.Models').factory "Admin.ScheduleModel", ($q, BBModel, BaseModel) ->

  class Admin_Schedule extends BaseModel

    constructor: (data) ->
      super(data)

