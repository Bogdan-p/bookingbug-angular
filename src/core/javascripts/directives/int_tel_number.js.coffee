app = angular.module 'BB.Directives'

###**
* @ngdoc directive
* @name BB.Directives:intTelNumber
* @restrict A
*
* @description
* {@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BB.Directives:intTelNumber
*
* International Telephone Input directive
*
* http://www.tooorangey.co.uk/posts/that-international-telephone-input-umbraco-7-property-editor/
*
* https://github.com/Bluefieldscom/intl-tel-input
*
* <pre>
* restrict: "A"
* require: "ngModel"
* </pre>
*
* Has the following set of methods:
*
* - link(scope, element, attrs, ctrl)
* - convertNumber(value)
*
###
app.directive "intTelNumber", ->

  # Restrict it to being an attribute
  restrict: "A"
  require: "ngModel"

  link: (scope, element, attrs, ctrl) ->

    options = scope.$eval attrs.intTelNumber
    # apply plugin
    element.intlTelInput options

    convertNumber = (value) ->

      str = ""
      if scope.$eval(attrs.ngModel + '_prefix')?
        str += ("+" + scope.$eval(attrs.ngModel + '_prefix') + " ")
      if scope.$eval(attrs.ngModel)?
        str += scope.$eval(attrs.ngModel)
      if str[0] == "+"
        element.intlTelInput("setNumber", "+#{scope.$eval(attrs.ngModel + '_prefix')} #{scope.$eval(attrs.ngModel)}")
        ctrl.$setValidity "pattern", true
      str

    ctrl.$formatters.push convertNumber
