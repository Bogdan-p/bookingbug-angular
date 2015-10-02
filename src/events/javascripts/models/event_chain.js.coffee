'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.EventChainModel
*
* @description
* This is Admin.EventChainModel in BB.Models module that creates Admin Event object.
*
* <pre>
* //Create class Admin_EventChain that extends BaseModel
* class Admin_EventChain extends BaseModel
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

angular.module('BB.Models').factory "Admin.EventChainModel", ($q, BBModel, BaseModel) ->

  class Admin_EventChain extends BaseModel

    constructor: (data) ->
      super(data)

