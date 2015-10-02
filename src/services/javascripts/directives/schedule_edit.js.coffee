###**
* @ngdoc directive
* @name BBAdminServices.Directives:scheduleEdit
*
* @description
*{@link https://docs.angularjs.org/guide/directive more about Directives}
*
* Directive BBAdminServices.Directives:scheduleEdit
*
* # Has the following set of methods:
*
* - link (scope, element, attrs, ngModel)
* - ngModel.$render ()
* 
###

angular.module('BBAdminServices').directive 'scheduleEdit', () ->

  link = (scope, element, attrs, ngModel) ->

    ngModel.$render = () ->
      scope.$$value$$ = ngModel.$viewValue

    scope.$watch '$$value$$', (value) ->
      ngModel.$setViewValue(value) if value?

  {
    link: link
    templateUrl: 'schedule_edit_main.html'
    require: 'ngModel'
  }


angular.module('schemaForm').config (schemaFormProvider,
    schemaFormDecoratorsProvider, sfPathProvider) ->

  schemaFormDecoratorsProvider.addMapping(
    'bootstrapDecorator'
    'schedule'
    'schedule_edit_form.html'
  )

  schemaFormDecoratorsProvider.createDirective(
    'schedule'
    'schedule_edit_form.html'
  )
