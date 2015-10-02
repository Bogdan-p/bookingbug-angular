'use strict';

###**
* @ngdoc object
* @name BB.Models:Admin.ServiceModel
*
* @description
* This is Admin.ServiceModel in BB.Models module that creates Admin ServiceModel object.
*
* <pre>
* //Creates class Admin_Service that extends ServiceModel
* class class Admin_Service extends ServiceModel
* </pre>
*
* @returns {object} Newly created Admin.ServiceModel object with the following set of methods:
*
###

angular.module('BB.Models').factory "Admin.ServiceModel", ($q, BBModel, ServiceModel) ->


  class Admin_Service extends ServiceModel
