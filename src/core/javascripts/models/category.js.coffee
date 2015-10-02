
'use strict';

###**
* @ngdoc object
* @name BB.Models:CategoryModel
*
* @description
* This is CategoryModel in BB.Models module that creates Category object.
*
* <pre>
* //Creates class Category that extends BaseModel
* class Category extends BaseModel
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
* @returns {object} Newly created Category object with the following set of methods:
*
###
angular.module('BB.Models').factory "CategoryModel", ($q, BBModel, BaseModel) ->

  class Category extends BaseModel

