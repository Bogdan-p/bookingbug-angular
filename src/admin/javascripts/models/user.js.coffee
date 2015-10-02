'use strict';

###**
* @ngdoc object
* @name BB.Models:Admin.UserModel
*
* @description
* This is UserModel model for Admin in BB.Models module that creates User object.
*
* <pre>
* //Creates class User that extends BaseModel
* class User extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
*
* @returns {object} Newly created User object.
*
###
angular.module('BB.Models').factory "Admin.UserModel", ($q, BBModel, BaseModel) ->

  class User extends BaseModel

