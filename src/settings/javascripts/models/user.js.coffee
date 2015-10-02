'use strict';

###**
* @ngdoc object
* @name BB.Models:Admin.UserModel
*
* @description
* path: src/services/javascripts/models/address.js.coffee
*
* This is UserModel in BB.Model module that creates Administrator Model object.
*
* <pre>
* //Creates class Admin_User class that extends BaseModel
*   class Admin_User extends BaseModel
* </pre>
*
* # Returns newly created UserModel object with the following set of methods:
*
* - constructor: (data)
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
*
###

angular.module('BB.Models').factory "Admin.UserModel", ($q, BBModel, BaseModel) ->

  class Admin_User extends BaseModel

    constructor: (data) ->
      super(data)
      @companies = []
      if data
        if @$has('companies')
          @$get('companies').then (comps) =>
            @companies = comps


