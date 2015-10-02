

class window.Collection.Client extends window.Collection.Base


  checkItem: (item) ->
    super

###**
* @ngdoc object
* @name BB.Services:ClientCollections
*
* @description
* It creates new Client Collections
*
* # Has the following set of methods:
* - $get
*
###

angular.module('BB.Services').provider "ClientCollections", () ->
  $get: ->
    new  window.BaseCollections()




