'use strict';

###**
* @ngdoc object
* @name BB.Models:AnswerModel
*
* @description
* This is AnswerModel in BB.Models module that creates Answer object.
*
* <pre>
* //Creates class Answer that extends BaseModel
* class Answer extends BaseModel
* </pre>
*
* @requires {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @requires {model} $bbug Releases the hold on the $ shortcut identifier, so that other scripts can use it.
* <br>
* {@link $bbug more}
*
* @requires {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @requires {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @returns {object} Newly created Answer object with the following set of methods:
*
* - constructor(data)
###
angular.module('BB.Models').factory "AnswerModel", ($q, BBModel, BaseModel, $bbug) ->

  class Answer extends BaseModel
    constructor: (data) ->
      super(data)

    getQuestion: () ->
      defer = $q.defer()
      defer.resolve(@question) if @question
      if @_data.$has('question')
        @_data.$get('question').then (question) =>
          @question = question
          defer.resolve(@question)
      else
        defer.resolve([])
      defer.promise

