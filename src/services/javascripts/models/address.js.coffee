'use strict';

###**
* @ngdoc object
* @name BB.Models:Admin.AddressModel
*
* @description
* path: src/services/javascripts/models/address.js.coffee
*
* This is AddressModel in BB.Model module that creates Address Model object.
*
* <pre>
* //Creates class Admin_Address class that extends AddressModel
*   class Admin_Address extends AddressModel
* </pre>
*
* ## Returns newly created AddressModel object with the following set of methods:
* - distanceFrom: (address, options)
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
* @requires BB.Models:AddressModel
*
###
angular.module('BB.Models').factory "Admin.AddressModel", ($q, BBModel, BaseModel, AddressModel) ->

  class Admin_Address extends AddressModel

    ###**
    * @ngdoc method
    * @name distanceFrom
    * @methodOf BB.Models:Admin.AddressModel
    *
    * @description
    * distanceFrom
    *
    * @param {object} address address
    * @param {object} options options
    *
    * @returns {array} this.dists[address]
    *
    ###
    distanceFrom: (address, options) ->

      @dists ||= []
      @dists[address] ||= Math.round(Math.random() * 50, 0)
      return @dists[address]
