###**
* @ngdoc object
* @name BB.Models:Member.MemberModel
*
* @description
* This is Member.MemberModel in BB.Models module that creates Member object.
*
* <pre>
* //Creates class Member_Member that extends ClientModel
* class Member_Member extends ClientModel
* </pre>
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
* @requires BB.Models:ClientModel
*
* @returns {object} Newly created Member object with the following set of methods:
*
* 
###

angular.module('BB.Models').factory "Member.MemberModel", ($q, BBModel,
    BaseModel, ClientModel) ->

  class Member_Member extends ClientModel

