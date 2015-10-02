
'use strict';

###**
* @ngdoc object
* @name BB.Models:CompanySettingsModel
*
* @description
* This is CompanySettingsModel in BB.Models module that creates CompanySettings object.
*
* <pre>
* //Creates class CompanySettings that extends BaseModel
* class CompanySettings extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* * <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @returns {object} Newly created CompanySettings object with the following set of methods:
*
###
angular.module('BB.Models').factory "CompanySettingsModel", ($q, BBModel, BaseModel) ->

  class CompanySettings extends BaseModel

