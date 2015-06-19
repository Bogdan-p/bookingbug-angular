'use strict'

angular.module('BB.Directives').directive 'bbPayForm', ($window, $timeout, $sce, $http, $compile, $document, $location) ->

  applyCustomPartials = (custom_partial_url, scope, element) ->
    if custom_partial_url?
      $document.domain = "bookingbug.com"
      $http.get(custom_partial_url).then (custom_templates) ->
        $compile(custom_templates.data) scope, (custom, scope) ->
          for e in custom
            if e.tagName == "STYLE"
              element.after(e.outerHTML)
          custom_form = (e for e in custom when e.id == 'payment_form')
          if custom_form and custom_form[0]
            $compile(custom_form[0].innerHTML) scope, (compiled_form, scope) ->
              form = element.find('form')[0]
              action = form.action
              compiled_form.attr('action', action)
              $(form).replaceWith(compiled_form)

  linker = (scope, element, attributes) ->
    $window.addEventListener 'message', (event) =>
      if angular.isObject(event.data)
        data = event.data
      else if angular.isString(event.data) and not event.data.match(/iFrameSizer/)
        data = JSON.parse event.data
      if data
        switch data.type
          when "load"
            scope.$apply =>
              scope.referrer = data.message
              if data.custom_partial_url
                applyCustomPartials(event.data.custom_partial_url, scope, element)
              if data.stylesheet

                css_id = 'custom_css'
                # you could encode the css path itself to generate id..
                if !document.getElementById(cssId)
                  head = document.getElementsByTagName('head')[0]
                  link = document.createElement('link')
                  link.id = css_id
                  link.rel = 'stylesheet'
                  link.type = 'text/css'
                  link.href = data.stylesheet
                  link.media = 'all'
                  head.appendChild link


    , false

  return {
    restrict: 'AE'
    replace: true
    scope: true
    controller: 'PayForm'
    link: linker
  }

angular.module('BB.Controllers').controller 'PayForm', ($scope, $location) ->

  $scope.controller = "public.controllers.PayForm"

  $scope.setTotal = (total) ->
    $scope.total = total

  $scope.setCard = (card) ->
    $scope.card = card


  sendSubmittingEvent = () =>
    referrer = $location.protocol() + "://" + $location.host()
    if $location.port()
      referrer += ":" + $location.port()
    target_origin = $scope.referrer

    payload = JSON.stringify({
      'type': 'submitting',
      'message': referrer
    })
    parent.postMessage(payload, target_origin)
 
  submitPaymentForm = () =>
    payment_form = angular.element.find('form')
    payment_form[0].submit()

  $scope.submitAndSendMessage = (event) =>
    event.preventDefault()
    event.stopPropagation()
    payment_form = $scope.$eval('payment_form')
    if payment_form.$invalid
      payment_form.submitted = true
      return false
    else
      sendSubmittingEvent()
      submitPaymentForm()



