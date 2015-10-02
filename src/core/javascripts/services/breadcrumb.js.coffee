###**
* @ngdoc service
* @name BB.Services:BreadcrumbService
*
* @description
* Factory BreadcrumbService
*
* @returns {Promise} This service has the following set of methods:
*
* - setCurrentStep(step)
* - getCurrentStep()
*
###
angular.module('BB.Services').factory "BreadcrumbService",  () ->

  current_step = 1

  setCurrentStep: (step) ->
    current_step = step

  getCurrentStep: () ->
    return current_step
