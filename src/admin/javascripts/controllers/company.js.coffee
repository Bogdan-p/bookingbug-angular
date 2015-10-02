###**
* @ngdoc controller
* @name BBAdmin.Controllers:CompanyList
*
* @description
* Controller CompanyList
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
###
angular.module('BBAdmin.Controllers').controller 'CompanyList', ($scope,  $rootScope, $location) ->
  $scope.selectedCategory = null;

  $rootScope.connection_started.then =>
    date = moment();
    $scope.current_date = date
    $scope.companies = $scope.bb.company.companies;
    if !$scope.companies || $scope.companies.length == 0
      $scope.companies = [$scope.bb.company]
    $scope.dates = []
    end = moment(date).add(21, 'days')
    $scope.end_date = end
    d = moment(date)
    while d.isBefore(end)
      $scope.dates.push(d.clone())
      d.add(1, 'days')

  $scope.selectCompany = (item) ->
    window.location = "/view/dashboard/pick_company/" + item.id;
#    $location.path(route)

  $scope.advance_date = (num) ->
    date = $scope.current_date.add(num, 'days')
    $scope.end_date =  moment(date).add(21, 'days')
    $scope.current_date = moment(date)
    $scope.dates = []
    d = date.clone()
    while d.isBefore($scope.end_date)
      $scope.dates.push(d.clone())
      d.add(1, 'days')

  $scope.$on "Refresh_Comp", (event, message)->
      $scope.$apply()

