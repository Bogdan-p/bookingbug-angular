###**
* @ngdoc service
* @name BB.Services:Dialog
*
* @description
* Factory Dialog
*
* @param {service} $modal is a service to quickly create AngularJS-powered modal windows. Creating custom modals is straightforward: create a partial view, its controller and reference them when using the service.
* <br>
* {@link https://github.com/angular-ui/bootstrap/tree/master/src/modal/docs more}
*
* @param {service} $log Simple service for logging.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$log more}
*
###
angular.module('BB.Services').factory 'Dialog', ($modal, $log) ->

  controller = ($scope, $modalInstance, model, title, success, fail, body) ->

    $scope.body = body

    $scope.ok = () ->
      $modalInstance.close(model)

    $scope.cancel = () ->
      event.preventDefault()
      event.stopPropagation()
      $modalInstance.dismiss('cancel')

    $modalInstance.result.then () ->
      success(model) if success
    , () ->
      fail() if fail

  confirm: (config) ->
    templateUrl = config.templateUrl if config.templateUrl
    templateUrl ||= 'dialog.html'
    $modal.open
      templateUrl: templateUrl
      controller: controller
      size: config.size || 'sm'
      resolve:
        model: () -> config.model
        title: () -> config.title
        success: () -> config.success
        fail: () -> config.fail
        body: () -> config.body

