

class window.Collection.Clinic extends window.Collection.Base


  checkItem: (item) ->
    super


  matchesParams: (item) ->
    if @params.start_date
      @start_date ||= moment(@params.start_date)
      return false if @start_date.isAfter(item.date)
    if @params.end_date
      @end_date ||= moment(@params.end_date)
      return false if @end_date.isBefore(item.date)
    return true

###**
* @ngdoc object
* @name BBAdmin.Services:ClinicCollections
*
* @description
* It creates new Base Collections
*
* # Has the following set of methods:
* - $get
*
###
angular.module('BBAdmin.Services').provider "ClinicCollections", () ->
  $get: ->
    new  window.BaseCollections()




