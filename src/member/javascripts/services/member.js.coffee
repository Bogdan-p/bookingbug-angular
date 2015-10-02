###**
* @ngdoc service
* @name BB.Services:MemberService
*
* @description
* Factory MemberService
*
* @requires $q
* @requires halClient
* @requires $rootScope
* @requires BB.Models:BBModel
*
* @returns {Promise} This service has the following set of methods:
*
* - refresh(member)
* - current()
*
###

angular.module('BB.Services').factory "MemberService", ($q, halClient, $rootScope, BBModel) ->

  ###**
  * @ngdoc method
  * @name refresh
  * @methodOf BB.Services:MemberService
  *
  * @description
  * Method refresh
  *
  * @param {object} member member
  *
  * @returns {Promise} deferred.reject(err) or deferred.promise
  *
  ###

  refresh: (member) ->
    deferred = $q.defer()
    member.$flush('self')
    member.$get('self').then (member) =>
      member = new BBModel.Member.Member(member)
      deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name current
  * @methodOf BB.Services:MemberService
  *
  * @description
  * Method current
  *
  * @returns {Promise} deferred.promise
  *
  ###
    
  current: () ->
    deferred = $q.defer()
    callback = ->
      deferred.resolve($rootScope.member)
    setTimeout callback, 200
    # member = () ->
      # deferred.resolve($rootScope.member)
    deferred.promise
