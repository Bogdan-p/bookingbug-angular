'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.EventGroupModel
*
* @description
* This is Admin.EventGroupModel in BB.Models module that creates Admin Event object.
*
* <pre>
* //Create class Admin_EventGroup that extends BaseModel
* class Admin_EventGroup extends BaseModel
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

angular.module('BB.Models').factory "Admin.EventGroupModel", ($q, BBModel, BaseModel) ->

  class Admin_EventGroup extends BaseModel

    constructor: (data) ->
      super(data)

