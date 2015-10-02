'use strict';

###**
* @ngdoc object
* @name BB.Models:ClientDetailsModel
*
* @description
* This is ClientDetailsModel in BB.Models module that creates ClientDetails object.
*
* <pre>
* //Creates class ClientDetails that extends BaseModel
* class ClientDetails extends BaseModel
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
* @returns {object} Newly created ClientDetails object with the following set of methods:
*
* - constructor(data)
* - getPostData(questions)
* - setAnswers(answers)
*
###
angular.module('BB.Models').factory "ClientDetailsModel", ($q, BBModel, BaseModel) ->

  class ClientDetails extends BaseModel

    constructor: (data) ->
      super
      @questions = []
      if @_data
        for q in data.questions
          @questions.push( new BBModel.Question(q))
      @hasQuestions = (@questions.length > 0)


    getPostData : (questions) ->
      data = []
      for q in questions
        data.push({answer: q.answer, id: q.id, price: q.price})
      data


    # load the answers from an answer set - probably from loading an existing basket item
    setAnswers: (answers) ->
      # turn answers into a hash
      ahash = {}
      for a in answers
        ahash[a.question_id] = a

      for q in @questions
        if ahash[q.id]  # if we have answer for it
          q.answer = ahash[q.id].answer
