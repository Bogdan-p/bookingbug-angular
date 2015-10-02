###**
* @ngdoc directive
* @name BB.Directives:ngOptions
* @restrict A
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BB.Directives:ngOptions
*
* there is a some sort of 'redraw' bug in IE with select menus which display
* more than one option and the options are dynamically inserted. So only some of
* the text is displayed in the option until the select element recieves focus,
* at which point all the text is disaplyed. comment out the focus() calls below
* to see what happens.
*
* Has the following set of methods:
* - link(scope, element, attrs)
*
* @param {service} $sniffer AThis is very simple implementation of testing browser's features.
* <br>
* {@link https://github.com/angular/angular.js/blob/master/src/ng/sniffer.js more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
###
angular.module('BB.Directives').directive 'ngOptions', ($sniffer, $rootScope) ->
  restrict : 'A'
  link : (scope, el, attrs) ->
    size = parseInt attrs['size'], 10

    if !isNaN(size) and size > 1 and $sniffer.msie
      $rootScope.$on 'loading:finished', ->
        el.focus()
        $('body').focus()
