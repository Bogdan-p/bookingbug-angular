'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.ClientQueueModel
*
* @description
* This is Admin.ClientQueueModel in BB.Models module that creates Admin ClientQueue object.
*
* <pre>
* //Creates class Admin_ClientQueue that extends BaseModel
* class Admin_ClientQueue extends BaseModel
* </pre>
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
*
###

angular.module('BB.Models').factory "Admin.ClientQueueModel", ($q, BBModel, BaseModel) ->

  class Admin_ClientQueue extends BaseModel