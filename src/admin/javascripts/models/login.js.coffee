'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.LoginMoadel
*
* @description
* This is LoginMoadel for Admin in BB.Models module that creates Admin_Login object.
*
* <pre>
* //Creates class Admin_Login that extends BaseModel
* class Admin_Login extends BaseModel
* </pre>
*
* @requires {string} $q Document the parameter to a function.
*
* @requires {string} BBModel Document the parameter to a function.
*
* @requires {string} BaseModel the parameter to a function.
*
* @returns {object} Newly created Admin_Login object.
*
###
angular.module('BB.Models').factory "Admin.LoginMoadel", ($q, BBModel, BaseModel) ->

  ###**
  * @ngdoc method
  * @name constructor
  * @methodOf BB.Models:Admin.LoginMoadel
  *
  * @description
  * Method constructor. Creates Admin_Login object.
  *
  * @requires {object} data Info
  ###
  class Admin_Login extends BaseModel
    constructor: (data) ->
      super(data)

