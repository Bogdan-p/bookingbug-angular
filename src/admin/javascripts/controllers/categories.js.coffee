###**
* @ngdoc controller
* @name BBAdmin.Controllers:CategoryList
*
* @description
* Controller CategoryList
*
* @param {object} $scope Scope is an object that refers to the application mode.
* <br>
* {@link https://docs.angularjs.org/guide/scope read more}
*
* @param {object} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope read more}
*
* @param {service} $location The $location service parses the URL in the browser address bar
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$location read more}
*
* @param {service} CategoryService Service.
*
###
angular.module('BBAdmin.Controllers').controller 'CategoryList', ($scope,  $location, CategoryService, $rootScope) ->

  $rootScope.connection_started.then =>
    $scope.categories = CategoryService.query($scope.bb.company)

    $scope.categories.then (items) =>


  $scope.$watch 'selectedCategory', (newValue, oldValue) =>
    $rootScope.category = newValue

    items = $('.inline_time').each (idx, e) ->
      angular.element(e).scope().clear()

  $scope.$on "Refresh_Cat", (event, message) =>
    $scope.$apply()


