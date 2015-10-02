###**
* @ngdoc object
* @name BB.Models:PrePaidBookingModel
*
* @description
* This is PrePaidBookingModel in BB.Models module that creates PrePaidBooking object.
*
* <pre>
* //Creates class PrePaidBooking that extends BaseModel
* class PrePaidBooking extends BaseModel
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
* @returns {object} Newly created PrePaidBooking object with the following set of methods:
*
###
angular.module('BB.Models').factory "PrePaidBookingModel", ($q, BBModel, BaseModel) ->

  class PrePaidBooking extends BaseModel
