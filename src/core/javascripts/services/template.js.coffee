# Service for loading templates and partials. return rasterized dom elements
###**
* @ngdoc service
* @name BB.Services:TemplateSvc
*
* @description
* Factory TemplateSvc
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q more}
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {service} $templateCache $templateCache
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$templateCachee more}
*
* @param {service} The $http service is a core Angular service that facilitates communication with the remote HTTP servers via the browser's XMLHttpRequest object or via JSONP.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$http more}
*
* @returns {Promise} This service has the following set of methods:
*
* - get(path)
*
###
angular.module('BB.Services').factory "TemplateSvc", ($q, $http, $templateCache, BBModel) ->
  get: (path) ->
    deferred = $q.defer()
    cacheTmpl = $templateCache.get(path);

    if cacheTmpl
      deferred.resolve(angular.element(cacheTmpl))
    else
      $http
        method: 'GET'
        url: path
      .success (tmpl, status) ->
        $templateCache.put(path, tmpl);
        deferred.resolve(angular.element(tmpl))
      .error (data, status) ->
        deferred.reject data
    deferred.promise

