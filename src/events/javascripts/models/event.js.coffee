'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.EventModel
*
* @description
* This is Admin.EventModel in BB.Models module that creates Admin Event object.
*
* <pre>
* //Create class Admin_Event that extends BaseModel
* class Admin_Event extends BaseModel
* </pre>
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
*
* @returns {object} Newly created Admin Event object with the following set of methods:
*
* - constructor(data)
*
###

angular.module('BB.Models').factory "Admin.EventModel", ($q, BBModel, BaseModel) ->

  class Admin_Event extends BaseModel

    constructor: (data) ->
      super(data)

