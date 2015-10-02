'use strict';

###**
* @ngdoc object
* @name BB.Models:QuestionModel
*
* @description
* This is QuestionModel in BB.Models module that creates Question object.
*
* <pre>
* //Creates class Question that extends BaseModel
* class Question extends BaseModel
* </pre>
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* * <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {service} $filter Filters are used for formatting data displayed to the user.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$filter more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} BaseModel Info
* <br>
* {@link BB.Models:BaseModel more}
*
* @returns {object} Newly created Question object with the following set of methods:
*
* - constructor(data)
* - hasPrice()
* - selectedPrice()
* - selectedPriceQty(qty)
* - getAnswerId()
* - showElement()
* - hideElement()
* - getPostData()
*
###
angular.module('BB.Models').factory "QuestionModel", ($q, $filter, BBModel, BaseModel) ->

  class Question extends BaseModel

    constructor: (data) ->
      # weirdly quesiton is  not currently initited as a hal object
      super(data)

      if @price
        @price = parseFloat(@price)
      if @_data.default
        @answer=@_data.default
      if @_data.options
        for option in @_data.options
          if option.is_default
            @answer=option.name
          if @hasPrice()
            option.price = parseFloat(option.price)
            currency = if data.currency_code then data.currency_code else 'GBP'
            option.display_name = "#{option.name} (#{$filter('currency')(option.price, currency)})"
          else
            option.display_name = option.name
      if @_data.detail_type == "check" || @_data.detail_type == "check-price"
        @answer =(@_data.default && @_data.default == "1")

      @currentlyShown = true

    hasPrice: ->
      return @detail_type == "check-price" || @detail_type == "select-price"  || @detail_type == "radio-price"

    selectedPrice: ->
      return 0 if !@hasPrice()
      if @detail_type == "check-price"
        return (if @answer then @price else 0)
      for option in @_data.options
        return option.price if @answer == option.name
      return 0

    selectedPriceQty: (qty) ->
      qty ||= 1
      p = @selectedPrice()
      if @price_per_booking
        p = p * qty
      p

    getAnswerId: ->
      return null if !@answer || !@options || @options.length == 0
      for o in @options
        return o.id if @answer == o.name
      return null

    showElement: ->
      @currentlyShown = true

    hideElement: ->
      @currentlyShown = false

    getPostData: ->
      x = {}
      x.id = @id
      x.answer = @answer
      x.answer = moment(@answer).toISODate() if @detail_type == "date" && @answer
      p = @selectedPrice()
      x.price = p if p
      x
