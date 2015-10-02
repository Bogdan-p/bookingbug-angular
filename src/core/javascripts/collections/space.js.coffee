

class window.Collection.Space extends window.Collection.Base


  checkItem: (item) ->
    super

###**
* @ngdoc object
* @name BB.Services:SpaceCollections
*
* @description
* It creates new SpaceCollections
*
* # Has the following set of methods:
*
* - $get
*
###

angular.module('BB.Services').provider "SpaceCollections", () ->
  $get: ->
    new  window.BaseCollections()




