'use strict';

###**
* @ngdoc object
* @name BB.Models:ItemDetailsModel
*
* @description
* This is ItemDetailsModel in BB.Models module that creates ItemDetails object.
*
* <pre>
* //Creates class ItemDetails that extends BaseModel
* class ItemDetails extends BaseModel
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
* @param {model} $bbug Releases the hold on the $ shortcut identifier, so that other scripts can use it.
* <br>
* {@link $bbug more}
*
* @param {model} QuestionService Info
* <br>
* {@link BB.Services:QuestionService more}
*
* @returns {object} Newly created ItemDetails object with the following set of methods:
*
* - constructor(data)
* - questionPrice(qty)
* - getPostData()
* - setAnswers(answers)
* - getQuestion(id)
*
###
angular.module('BB.Models').factory "ItemDetailsModel", ($q, BBModel, BaseModel, $bbug, QuestionService) ->

  class ItemDetails extends BaseModel

    constructor: (data) ->
      @_data = data
      if @_data
        @self = @_data.$href("self")
      @questions = []
      @survey_questions = []
      if data
        for q in data.questions
          if (q.outcome) == false
            if data.currency_code then q.currency_code = data.currency_code
            @questions.push( new BBModel.Question(q))
          else
            @survey_questions.push( new BBModel.SurveyQuestion(q))
      @hasQuestions = (@questions.length > 0)
      @hasSurveyQuestions = (@survey_questions.length > 0)


    questionPrice: (qty) ->
      qty ||= 1
      @checkConditionalQuestions()
      price = 0
      for q in @questions
        price += q.selectedPriceQty(qty)
      price

    checkConditionalQuestions: () ->
      QuestionService.checkConditionalQuestions(@questions)


    getPostData: ->
      data = []
      for q in @questions
        data.push(q.getPostData()) if q.currentlyShown
      data

    # load the answers from an answer set - probably from loading an existing basket item
    setAnswers: (answers) ->
      # turn answers into a hash
      ahash = {}
      for a in answers
        ahash[a.id] = a

      for q in @questions
        if ahash[q.id]  # if we have answer for it
          q.answer = ahash[q.id].answer
      @checkConditionalQuestions()

    getQuestion: (id) ->
      _.findWhere(@questions, {id: id})
