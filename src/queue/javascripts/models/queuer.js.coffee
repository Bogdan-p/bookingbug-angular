'use strict'

###**
* @ngdoc object
* @name BB.Models:Admin.QueuerModel
*
* @description
* This is Admin.Queuer in BB.Models module that creates Admin Queuer object.
*
* <pre>
* //Creates class QueuerModel that extends BaseModel
* class Admin_Queuer extends BaseModel
* </pre>
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
*
###

angular.module('BB.Models').factory("QueuerModel", ["$q", "BBModel", "BaseModel", ($q, BBModel, BaseModel) ->

	class Queuer extends BaseModel

])

