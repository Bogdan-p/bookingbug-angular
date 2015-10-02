###**
* @ngdoc object
* @name BB.Models:Admin.ResourceModel
*
* @description
* This is Admin.ResourceModel in BB.Model module that creates Admin Resource Model object.
*
* <pre>
*  //Creates class Admin_Resources that extends ResourceModel
*   class Admin_Resource extends ResourceModel
* </pre>
*
* @requires $q
* @requires BB.Models:BBModel
* @requires BB.Models:BaseModel
* @requires BB.Models:ResourceModel
*
* @returns {object} Newly created Admin.ResourceModel object with the following set of methods:
*
* - isAvailable(start, end)
*
###
 
'use strict';

angular.module('BB.Models').factory "Admin.ResourceModel", ($q, BBModel, BaseModel, ResourceModel) ->

  class Admin_Resource extends ResourceModel

    ###**
    * @ngdoc method
    * @name isAvailable
    * @methodOf BB.Models:Admin.ResourceModel
    *
    * @description
    * isAvailable
    *
    * @param {object} start start
    * @param {object} end end
    *
    * @returns {array} this.availability[str]
    *
    ###

    # look up a schedule for a time range to see if this available
    # currently just checks the date - but chould really check the time too
    isAvailable: (start, end) ->
      str = start.format("YYYY-MM-DD") + "-" + end.format("YYYY-MM-DD")
      @availability ||= {}
      
      return @availability[str] if @availability[str]
      @availability[str] = "-"

      if @$has('schedule')
        @$get('schedule', {start_date: start.format("YYYY-MM-DD"), end_date: end.format("YYYY-MM-DD")}).then (sched) =>
          @availability[str] = "No"
          if sched && sched.dates && sched.dates[start.format("YYYY-MM-DD")] && sched.dates[start.format("YYYY-MM-DD")] != "None"
            @availability[str] = "Yes"
      else
        @availability[str] = "Yes"

      return @availability[str]  