'use strict';

###**
* @ngdoc object
* @name BB.Models:ImageModel
*
* @description
* This is ImageModel in BB.Models module that creates Image object.
*
* <pre>
* //Creates class Image that extends BaseModel
* class Image extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* * <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $filter Filters are used for formatting data displayed to the user.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$filter more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @returns {object} Newly created Image object with the following set of methods:
*
* - constructor(data)
*
###
angular.module('BB.Models').factory "ImageModel", ($q, $filter, BBModel, BaseModel) ->

  class Image extends BaseModel

    constructor: (data) ->
      super(data)
