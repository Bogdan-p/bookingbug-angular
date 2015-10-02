

class window.Collection.Day extends window.Collection.Base


  checkItem: (item) ->
    super

###**
* @ngdoc object
* @name BB.Services:DayCollections
*
* @description
* It creates new DayCollections
*
* # Has the following set of methods:
*
* - $get
*
###

angular.module('BB.Services').provider "DayCollections", () ->
  $get: ->
    new  window.BaseCollections()
  



