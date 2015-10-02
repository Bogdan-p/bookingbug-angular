'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.AdministratorModel
*
* @description
* path: src/services/javascripts/models/address.js.coffee
*
* This is AdministratorModel in BB.Model module that creates Administrator Model object.
*
* <pre>
* //Creates class Admin_Administrator class that extends BaseModel
*   class Admin_Administrator extends BaseModel
* </pre>
*
* # Returns newly created AdministratorModel object with the following set of methods:
*
* - constructor: (data)
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
*
###

angular.module('BB.Models').factory "Admin.AdministratorModel", ($q, BBModel, BaseModel) ->

  class Admin_Administrator extends BaseModel

    constructor: (data) ->
      super(data)

