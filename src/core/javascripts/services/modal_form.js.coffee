###**
* @ngdoc service
* @name BB.Services:ModalForm
*
* @description
* Factory ModalForm
*
* @param {service} $modal is a service to quickly create AngularJS-powered modal windows. Creating custom modals is straightforward: create a partial view, its controller and reference them when using the service.
* <br>
* {@link https://github.com/angular-ui/bootstrap/tree/master/src/modal/docs more}
*
* @param {service} $log Simple service for logging.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$log more}
*
* @param {model} Dialog Info
* <br>
* {@link BB.Services:Dialog more}
*
* @returns {Promise} This service has the following set of methods:
*
* - $scope.submit(form)
* - $scope.cancel
* - editForm($scope, $modalInstance, model, title, success, fail)
* - $scope.submit(form)
* - $scope.cancel(event)
* - $scope.cancelBooking(event)
* - new(config)
* - edit(config)
*
###
angular.module('BB.Services').factory 'ModalForm', ($modal, $log, Dialog) ->

  newForm = ($scope, $modalInstance, company, title, new_rel, post_rel,
      success, fail) ->

    $scope.loading = true
    $scope.title = title
    $scope.company = company
    if $scope.company.$has(new_rel)
      $scope.company.$get(new_rel).then (schema) ->
        $scope.form = _.reject schema.form, (x) -> x.type == 'submit'
        $scope.schema = schema.schema
        $scope.form_model = {}
        $scope.loading = false
    else
      $log.warn("company does not have '#{new_rel}' rel")

    $scope.submit = (form) ->
      $scope.$broadcast('schemaFormValidate')
      $scope.loading = true
      $scope.company.$post(post_rel, {}, $scope.form_model).then (model) ->
        $scope.loading = false
        $modalInstance.close(model)
        success(model) if success
      , (err) ->
        $scope.loading = false
        $modalInstance.close(err)
        $log.error 'Failed to create'
        fail(err) if fail

    $scope.cancel = (event) ->
      event.preventDefault()
      event.stopPropagation()
      $modalInstance.dismiss('cancel')

  editForm = ($scope, $modalInstance, model, title, success, fail) ->
    $scope.loading = true
    $scope.title = title
    $scope.model = model
    if $scope.model.$has('edit')
      $scope.model.$get('edit').then (schema) ->
        $scope.form = _.reject schema.form, (x) -> x.type == 'submit'
        $scope.schema = schema.schema
        $scope.form_model = $scope.model
        $scope.loading = false
    else
      $log.warn("model does not have 'edit' rel")

    $scope.submit = (form) ->
      $scope.$broadcast('schemaFormValidate')
      $scope.loading = true
      if $scope.model.$update
        $scope.model.$update($scope.form_model).then () ->
          $scope.loading = false
          $modalInstance.close($scope.model)
          success($scope.model) if success
        , (err) ->
          $scope.loading = false
          $modalInstance.close(err)
          $log.error 'Failed to create'
          fail() if fail
      else
        $scope.model.$put('self', {}, $scope.form_model).then (model) ->
          $scope.loading = false
          $modalInstance.close(model)
          success(model) if success
        , (err) ->
          $scope.loading = false
          $modalInstance.close(err)
          $log.error 'Failed to create'
          fail() if fail

    $scope.cancel = (event) ->
      event.preventDefault()
      event.stopPropagation()
      $modalInstance.dismiss('cancel')

    $scope.cancelBooking = (event) ->
      event.preventDefault()
      event.stopPropagation()
      $modalInstance.close()
      Dialog.confirm
        model: model
        body: "Are you sure you want to cancel this booking?"
        success: (model) ->
          model.$del('self').then (response) ->
            success(response) if success

  new: (config) ->
    templateUrl = config.templateUrl if config.templateUrl
    templateUrl ||= 'modal_form.html'
    $modal.open
      templateUrl: templateUrl
      controller: newForm
      size: config.size
      resolve:
        company: () -> config.company
        title: () -> config.title
        new_rel: () -> config.new_rel
        post_rel: () -> config.post_rel
        success: () -> config.success
        fail: () -> config.fail

  edit: (config) ->
    templateUrl = config.templateUrl if config.templateUrl
    templateUrl ||= 'modal_form.html'
    $modal.open
      templateUrl: templateUrl
      controller: editForm
      size: config.size
      resolve:
        model: () -> config.model
        title: () -> config.title
        success: () -> config.success
        fail: () -> config.fail

