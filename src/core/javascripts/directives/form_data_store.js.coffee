'use strict';

#
###**
* @ngdoc directive
* @name BB.Directives:bbFormDataStore
*
* @description
* Directive BB.Directives:bbFormDataStore
* <br>
* This does very little apart from register the widget, so the user's form choices are stored.
*
* <pre>
* require : '?bbWidget'
* </pre>
*
* # Has the following set of methods:
*
* -  link(scope)
*
* @param {service} FormDataStoreService Info
* <br>
* {@link BB.Services:FormDataStoreService more}
*
###
angular.module('BB.Directives').directive 'bbFormDataStore', (FormDataStoreService) ->
  #  remove '?' when we change over the bbWidget directive
  require : '?bbWidget'
  link : (scope) ->
    FormDataStoreService.register scope

