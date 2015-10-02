app = angular.module 'BB.Directives'

###**
* @ngdoc directive
* @name BB.Directives:ngConfirmClick
*
* # Has the following set of methods:
*
* - link: (scope, element, attr)
*
* @description
* Directive BB.Directives:ngConfirmClick
*
###
app.directive 'ngConfirmClick', () ->
  link: (scope, element, attr) ->
    msg = attr.ngConfirmClick || "Are you sure?";
    clickAction = attr.ngConfirmedClick;
    element.bind 'click', (event) =>
      if window.confirm(msg)
        scope.$eval(clickAction)

###**
* @ngdoc directive
* @name BB.Directives:ngValidInclude
*
* @description
* Directive BB.Directives:ngValidInclude
*
* # Has the following set of methods:
*
* - link(scope, element, attr)
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
###
app.directive 'ngValidInclude', ($compile) ->
    link: (scope, element, attr) ->
      scope[attr.watchValue].then (logged) =>
        element.attr('ng-include', attr.ngValidInclude)
        element.attr('ng-valid-include',null)
        $compile(element)(scope)

###**
* @ngdoc directive
* @name BB.Directives:ngDelayed
*
* @description
* Directive BB.Directives:ngDelayed
*
* # Has the following set of methods:
*
* - link(scope, element, attr)
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
###
app.directive 'ngDelayed',  ($compile) ->
    link: (scope, element, attr) ->
      scope[attr.ngDelayedWatch].then (logged) =>
        element.attr(attr.ngDelayed, attr.ngDelayedValue)
        element.attr('ng-delayed-value',null)
        element.attr('ng-delayed-watch',null)
        element.attr('ng-delayed',null)
        $compile(element)(scope)
        if attr.ngDelayedReady
          scope[attr.ngDelayedReady].resolve(true)

###**
* @ngdoc directive
* @name BB.Directives:ngInitial
* @restrict A
*
* @description
* Directive BB.Directives:ngInitial
*
* # Has the following set of methods:
*
* - link(scope, element, attr)
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
###
app.directive 'ngInitial', ->
    restrict: 'A',
    controller: [
      '$scope', '$element', '$attrs', '$parse', ($scope, $element, $attrs, $parse) ->
        val = $attrs.ngInitial || $attrs.value
        getter = $parse($attrs.ngModel)
        setter = getter.assign
        if val == "true"
          val = true
        else if val == "false"
          val = false
        setter($scope, val)
    ]

###**
* @ngdoc directive
* @name BB.Directives:bbPrintPage
* @restrict A
*
* @description
* Directive BB.Directives:bbPrintPage
*
* # Has the following set of methods:
*
* - link(scope, element, attr)
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @param {service} $timeout Angular's wrapper for window.setTimeout.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$timeout more}
*
###
app.directive 'bbPrintPage', ($window, $timeout) ->
  restrict: 'A',
  link:(scope, element, attr) ->
    if attr.bbPrintPage
      scope.$watch attr.bbPrintPage, (newVal, oldVal) =>
        $timeout(->
          $window.print()
        3000)

###**
* @ngdoc directive
* @name BB.Directives:bbInclude
*
* @description
* Directive BB.Directives:bbInclude
*
* # Has the following set of methods:
*
* - link(scope, element, attr)
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
###
app.directive 'bbInclude', ($compile, $rootScope) ->
  link: (scope, element, attr) ->
    track_page = if attr.bbTrackPage? then true else false
    scope.$watch 'bb.path_setup', (newval, oldval) =>
      if newval
        element.attr('ng-include', "'" + scope.getPartial(attr.bbInclude) + "'")
        element.attr('bb-include',null)
        $compile(element)(scope)
        $rootScope.$broadcast "page:loaded", attr.bbInclude if track_page

###**
* @ngdoc directive
* @name BB.Directives:bbRaiseAlertWhenInvalid
*
* @description
* Directive BB.Directives:bbRaiseAlertWhenInvalid
* Form directive to allow users to specify if they want the form to raise alerts when
* there is invalid input.
*
* # Has the following set of methods:
*
* - link(scope, element, attr, ctrl)
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
###
app.directive 'bbRaiseAlertWhenInvalid', ($compile) ->
  require: '^form'
  link: (scope, element, attr, ctrl) ->
    ctrl.raise_alerts = true

    options = scope.$eval attr.bbRaiseAlertWhenInvalid
    ctrl.alert = options.alert if options and options.alert


###**
* @ngdoc directive
* @name BB.Directives:bbHeader
*
* @description
* Directive BB.Directives:bbHeader
*
* # Has the following set of methods:
*
* - link(scope, element, attr)
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
###
app.directive 'bbHeader', ($compile) ->
    link: (scope, element, attr) ->
      scope.bb.waitForRoutes()
      scope.$watch 'bb.path_setup', (newval, oldval) =>
        if newval
          element.attr('ng-include', "'" + scope.getPartial(attr.bbHeader) + "'")
          element.attr('bb-header',null)
          $compile(element)(scope)

###**
* @ngdoc directive
* @name BB.Directives:bbDate
*
* @description
* Directive BB.Directives:bbDate
*
* # Has the following set of methods:
*
* - link(scope, element, attr)
*
###
app.directive 'bbDate', () ->
  restrict: 'AE'
  scope: true
  link : (scope, element, attrs) ->

    track_service = attrs.bbTrackService?

    # set the date, first test if bbDate has been set, otherwise use the current item's
    # date. If neither are set, set the date as today
    if attrs.bbDate
     date = moment( scope.$eval( attrs.bbDate ) )
    else if scope.bb && scope.bb.current_item && scope.bb.current_item.date
      date = scope.bb.current_item.date.date
    else
      date = moment()

    # if we've been instructed to track the service, set the min/max date
     if track_service && scope.bb.current_item && scope.bb.current_item.service
      scope.min_date = scope.bb.current_item.service.min_advance_datetime
      scope.max_date = scope.bb.current_item.service.max_advance_datetime

    # broadcast a dateChanged event to ensure listeners are updated
    scope.$broadcast('dateChanged', moment(date))

    # bb_date
    scope.bb_date = {

      date: date
      js_date: date.toDate()

      addDays: (type, amount) ->
        @date = moment(@date).add(amount, type)
        @js_date = @date.toDate()
        scope.$broadcast('dateChanged', moment(@date))

      subtractDays: (type, amount) ->
        @addDays(type, -amount)

      setDate: (date) ->
        @date    = date
        @js_date = date.toDate()
        scope.$broadcast('dateChanged', moment(@date))
    }

    # watch the current_item for updates
    scope.$on "currentItemUpdate", (event) ->

      # set the min/max date if a service has been set
      if scope.bb.current_item.service && track_service
        scope.min_date = scope.bb.current_item.service.min_advance_datetime
        scope.max_date = scope.bb.current_item.service.max_advance_datetime

        # if the bb_date is before/after the min/max date, move it to the min/max date
        scope.bb_date.setDate(scope.min_date.clone()) if scope.bb_date.date.isBefore(scope.min_date, 'day')
        scope.bb_date.setDate(scope.max_date.clone()) if scope.bb_date.date.isAfter(scope.max_date, 'day')

    # if the js_date has changed, update the moment date representation
    # and broadcast an update
    scope.$watch 'bb_date.js_date', (newval, oldval) ->
      ndate = moment(newval)
      if !scope.bb_date.date.isSame(ndate)
        scope.bb_date.date = ndate
        scope.$broadcast('dateChanged', moment(ndate)) if moment(ndate).isValid()

###**
* @ngdoc directive
* @name BB.Directives:bbDebounce
*
* @description
* Directive BB.Directives:bbDebounce
*
* # Has the following set of methods:
*
* - link(scope, element, attr)
*
* @param {service} $timeout Angular's wrapper for window.setTimeout.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$timeout more}
*
###
app.directive 'bbDebounce', ($timeout) ->
  restrict: 'A',
  link: (scope, element, attrs) ->
    delay = 400
    delay = attrs.bbDebounce if attrs.bbDebounce

    element.bind 'click', () =>
      $timeout () =>
        element.attr('disabled', true)
      , 0
      $timeout () =>
        element.attr('disabled', false)
      , delay

###**
* @ngdoc directive
* @name BB.Directives:bbLocalNumber
* @restrict A
*
* @description
* Directive BB.Directives:bbLocalNumber
* <br>
* Adds a formatter that prepends the model value with zero. This is useful for
* nicely formatting numbers where the prefix has been stripped, i.e. '7875123456'
*
* # Has the following set of methods:
*
* - link(scope, element, attr, ctrl)
*
###
app.directive 'bbLocalNumber', () ->
  restrict: 'A',
  require: 'ngModel',
  link: (scope, element, attrs, ctrl) ->

    prettyifyNumber = (value) ->
      if value and value[0] != "0"
        value = "0" + value
      else
        value
      return value

    ctrl.$formatters.push(prettyifyNumber)

###**
* @ngdoc directive
* @name BB.Directives:bbPadWithZeros
* @restrict A
*
* @description
* Directive BB.Directives:bbPadWithZeros
* <br>
* Adds a formatter that prepends the model value with the specified number of zeros.
*
* # Has the following set of methods:
*
* - link(scope, element, attr, ctrl)
*
###
app.directive 'bbPadWithZeros', () ->
  restrict: 'A',
  require: 'ngModel',
  link: (scope, element, attrs, ctrl) ->

    options  = scope.$eval(attrs.bbPadWithZeros) or {}
    how_many = options.how_many or 2

    padNumber = (value) ->
      value = String(value)
      if value and value.length < how_many
        padding = ""
        for index in [1..how_many-value.length]
          padding += "0"
         value = padding.concat(value)
      return value

    ctrl.$formatters.push(padNumber)

###**
* @ngdoc directive
* @name BB.Directives:bbFormResettable
* @restrict A
*
* @description
* Directive BB.Directives:bbFormResettable
* <br>
* Adds field clearing behaviour to forms.
*
* # Has the following set of methods:
*
* - controller($scope, $element, $attrs)
*
* @param {service} $parse Converts Angular expression into a function.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$parse more}
*
###
app.directive 'bbFormResettable', ($parse) ->
  restrict: 'A'
  controller: ($scope, $element, $attrs) ->
    $scope.inputs = []

    $scope.resetForm = (options) ->
      $scope[$attrs.name].submitted = false if options and options.clear_submitted
      for input in $scope.inputs
        input.getter.assign($scope, null)
        input.controller.$setPristine()

    registerInput: (input, ctrl) ->
      getter = $parse input
      $scope.inputs.push({getter: getter, controller: ctrl})

###**
* @ngdoc directive
* @name BB.Directives:bbResettable
* @restrict A
*
* @description
* Directive BB.Directives:bbResettable
* <br>
* Registers inputs with the bbFormResettable controller allowing them to be cleared.
*
* # Has the following set of methods:
*
* - controller(scope, element, attrs, ctrls)
*
###
app.directive 'bbResettable', () ->
  restrict: 'A',
  require: ['ngModel', '^bbFormResettable'],
  link: (scope, element, attrs, ctrls) ->
    ngModelCtrl        = ctrls[0]
    formResettableCtrl = ctrls[1]
    formResettableCtrl.registerInput(attrs.ngModel, ngModelCtrl)

###**
* @ngdoc directive
* @name BB.Directives:bbDateSplit
* @restrict A
*
* @description
* Directive BB.Directives:bbDateSplit
*
* # Has the following set of methods:
*
* - controller($scope, $element, $attrs)
*
* @param {service} $parse Converts Angular expression into a function.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$parse more}
*
###
app.directive 'bbDateSplit', ($parse) ->
  restrict: 'A'
  require: ['ngModel']
  link: (scope, element, attrs, ctrls) ->

    ngModel = ctrls[0]

    question = scope.$eval attrs.bbDateSplit

    question.date = {
      day:   null
      month: null
      year:  null
      date:  null

      joinDate:  ->
        if @day && @month && @year
          date_string = @day + '/' + @month + '/' + @year
          @date = moment(date_string, "DD/MM/YYYY")
          date_string = @date.toISODate()

          ngModel.$setViewValue(date_string)
          ngModel.$render()

      splitDate: (date) ->
        if date && date.isValid()
          @day   = date.date()
          @month = date.month() + 1
          @year  = date.year()
          @date  = date
    }

    # split the date if it's already set
    question.date.splitDate(moment(question.answer)) if question.answer
    question.date.splitDate(moment(ngModel.$viewValue)) if ngModel.$viewValue

    # watch self to split date when it changes
    # scope.$watch attrs.ngModel, (newval) ->
    #   if newval
    #     new_date = moment(newval)
    #     if !new_date.isSame(question.date)
    #        question.date.splitDate(new_date)


###**
* @ngdoc directive
* @name BB.Directives:bbCommPref
* @restrict A
*
* @description
* Directive BB.Directives:bbCommPref
*
* # Has the following set of methods:
*
* - controller($scope, $element, $attrs)
*
* @param {service} $parse Converts Angular expression into a function.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$parse more}
*
###
app.directive 'bbCommPref', ($parse) ->
  restrict: 'A'
  require: ['ngModel']
  link: (scope, element, attrs, ctrls) ->

    ngModelCtrl = ctrls[0]

    # get the default communication preference
    comm_pref_default = scope.$eval attrs.bbCommPref or false

    # and set it
    ngModelCtrl.$setViewValue(comm_pref_default)

    # watch for changes
    scope.$watch attrs.ngModel, (newval, oldval) ->
      if newval != oldval
        scope.bb.current_item.settings.send_email_followup = newval
        scope.bb.current_item.settings.send_sms_followup   = newval

###**
* @ngdoc directive
* @name BB.Directives:bbCountTicketTypes
* @restrict A
*
* @description
* Directive BB.Directives:bbCountTicketTypes
* <br>
* Returns the number of tickets purchased grouped by name.
*
* # Has the following set of methods:
*
* - controller(scope, element, attrs)
*
* @param {service} $parse Converts Angular expression into a function.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$parse more}
*
###
app.directive 'bbCountTicketTypes', () ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    items = scope.$eval(attrs.bbCountTicketTypes)
    counts = []
    for item in items
      if item.tickets
        if counts[item.tickets.name] then counts[item.tickets.name] += 1 else counts[item.tickets.name] = 1
        item.number = counts[item.tickets.name]


###**
* @ngdoc directive
* @name BB.Directives:bbCapitaliseFirstLetter
* @restrict A
*
* @description
* Directive BB.Directives:bbCapitaliseFirstLetter
*
* # Has the following set of methods:
*
* - controller$scope, element, attrs, ctrls)
*
* @param {service} $parse Converts Angular expression into a function.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$parse more}
*
###
app.directive 'bbCapitaliseFirstLetter', () ->
  restrict: 'A'
  require: ['ngModel']
  link: (scope, element, attrs, ctrls) ->
    ngModel = ctrls[0]

    scope.$watch attrs.ngModel, (newval, oldval) ->
      if newval
        string = scope.$eval attrs.ngModel
        string = string.charAt(0).toUpperCase() + string.slice(1)
        ngModel.$setViewValue(string)
        ngModel.$render()
        return

# Deprecate - see below

###**
* @ngdoc directive
* @name BB.Directives:apiUrl
* @restrict A
* @deprecated
*
* @description
* Directive BB.Directives:apiUrl
* <br>
* Please see {@link BB.Directives:bbApiUrl bbApiUrl}
*
* # Has the following set of methods:
*
* - compile(tElem, tAttrs)
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
* @param {service} $sniffer AThis is very simple implementation of testing browser's features.
* <br>
* {@link https://github.com/angular/angular.js/blob/master/src/ng/sniffer.js more}
*
* @param {service} $timeout Angular's wrapper for window.setTimeout.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$timeout more}
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
###
app.directive 'apiUrl', ($rootScope, $compile, $sniffer, $timeout, $window) ->
  restrict: 'A'
  replace: true
  compile: (tElem, tAttrs) ->
    pre: (scope, element, attrs) ->
      $rootScope.bb ||= {}
      $rootScope.bb.api_url = attrs.apiUrl
      url = document.createElement('a')
      url.href = attrs.apiUrl
      if ($sniffer.msie && $sniffer.msie < 10) && url.host != $window.location.host
        if url.protocol[url.protocol.length - 1] == ':'
          src = "#{url.protocol}//#{url.host}/ClientProxy.html"
        else
          src = "#{url.protocol}://#{url.host}/ClientProxy.html"
        $rootScope.iframe_proxy_ready = false
        $window.iframeLoaded = () ->
          $rootScope.iframe_proxy_ready = true
          $rootScope.$broadcast('iframe_proxy_ready', {iframe_proxy_ready: true})
        $compile("<iframe id='ieapiframefix' name='" + url.hostname + "' src='#{src}' style='visibility:false;display:none;' onload='iframeLoaded()'></iframe>") scope, (cloned, scope) =>
          element.append(cloned)

###**
* @ngdoc directive
* @name BB.Directives:bbApiUrl
* @restrict A
*
* @description
* Directive BB.Directives:bbApiUrl
*
* # Has the following set of methods:
*
* - compile(tElem, tAttrs)
*
* @param {service} $rootScope Every application has a single root scope.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$rootScope more}
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
* @param {service} $sniffer AThis is very simple implementation of testing browser's features.
* <br>
* {@link https://github.com/angular/angular.js/blob/master/src/ng/sniffer.js more}
*
* @param {service} $timeout Angular's wrapper for window.setTimeout.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$timeout more}
*
* @param {service} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window more}
*
* @param {service} $location The $location service parses the URL in the browser address bar
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$location more}
*
###
app.directive 'bbApiUrl', ($rootScope, $compile, $sniffer, $timeout, $window, $location) ->
  restrict: 'A'
  scope:
    'apiUrl': '@bbApiUrl'
  compile: (tElem, tAttrs) ->
    pre: (scope, element, attrs) ->
      $rootScope.bb ||= {}
      $rootScope.bb.api_url = scope.apiUrl
      url = document.createElement('a')
      url.href = scope.apiUrl
      if $sniffer.msie && $sniffer.msie < 10
        unless url.host == $location.host() || url.host == "#{$location.host()}:#{$location.port()}"
          if url.protocol[url.protocol.length - 1] == ':'
            src = "#{url.protocol}//#{url.host}/ClientProxy.html"
          else
            src = "#{url.protocol}://#{url.host}/ClientProxy.html"
          $rootScope.iframe_proxy_ready = false
          $window.iframeLoaded = () ->
            $rootScope.iframe_proxy_ready = true
            $rootScope.$broadcast('iframe_proxy_ready', {iframe_proxy_ready: true})
          $compile("<iframe id='ieapiframefix' name='" + url.hostname + "' src='#{src}' style='visibility:false;display:none;' onload='iframeLoaded()'></iframe>") scope, (cloned, scope) =>
            element.append(cloned)

###**
* @ngdoc directive
* @name BB.Directives:bbPriceFilter
* @restrict AE
* @require: ^?bbServices
*
* @description
* Directive BB.Directives:bbPriceFilter
*
* # Has the following set of methods:
*
* - templateUrl(element, attrs)
* - controller($scope, $attrs)
*
* @param {service} PathSvc Info
* <br>
* {@link BB.Services:PathSvc more}
*
###
app.directive 'bbPriceFilter', (PathSvc) ->
  restrict: 'AE'
  replace: true
  scope: false
  require: '^?bbServices'
  templateUrl : (element, attrs) ->
    PathSvc.directivePartial "_price_filter"
  controller : ($scope, $attrs) ->
    $scope.$watch 'items', (new_val, old_val) ->
      setPricefilter new_val if new_val

    setPricefilter = (items) ->
      $scope.price_array = _.uniq _.map items, (item) ->
        return item.price / 100 or 0
      $scope.price_array.sort (a, b) ->
        return a - b
      suitable_max()

    suitable_max = () ->
      top_number = _.last($scope.price_array)
      max_number = switch
        when top_number < 1 then 0
        when top_number < 11 then 10
        when top_number < 51 then 50
        when top_number < 101 then 100
        when top_number < 1000 then ( Math.ceil( top_number / 100 ) ) * 100
      min_number = 0
      $scope.price_options = {
        min: min_number
        max: max_number
      }
      $scope.filters.price = {min: min_number, max: max_number}

    $scope.$watch 'filters.price.min', (new_val, old_val) ->
      $scope.filterChanged() if new_val != old_val

    $scope.$watch 'filters.price.max', (new_val, old_val) ->
      $scope.filterChanged() if new_val != old_val

###**
* @ngdoc directive
* @name BB.Directives:bbBookingExport
* @restrict AE
* @scope true;
*
* @description
* Directive BB.Directives:bbBookingExport
*
* <pre>
* //template
* <div bb-include="_popout_export_booking" style="display: inline;"></div>
* </pre>
*
* <pre>
* scope.html = "
        <a class='image img_outlook' title='Add this booking to an Outlook Calendar' href='#{purchase_total.icalLink()}'><img alt='' src='//images.bookingbug.com/widget/outlook.png'></a>
        <a class='image img_ical' title='Add this booking to an iCal Calendar' href='#{purchase_total.webcalLink()}'><img alt='' src='//images.bookingbug.com/widget/ical.png'></a>
        <a class='image img_gcal' title='Add this booking to Google Calendar' href='#{purchase_total.gcalLink()}' target='_blank'><img src='//images.bookingbug.com/widget/gcal.png' border='0'></a>
      "
* </pre>
*
* # Has the following set of methods:
* - link(scope, element, attrs)
*
* @param {service} $compile Compiles an HTML string or DOM into a template and produces a template function, which can then be used to link scope and the template together.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$compile more}
*
###
app.directive 'bbBookingExport', ($compile) ->
  restrict: 'AE'
  scope: true
  template: '<div bb-include="_popout_export_booking" style="display: inline;"></div>'
  link: (scope, element, attrs) ->

    scope.$watch 'total', (newval, old) ->
      setHTML(newval) if newval

    scope.$watch 'purchase', (newval, old) ->
      setHTML(newval) if newval

    setHTML = (purchase_total) ->
      scope.html = "
        <a class='image img_outlook' title='Add this booking to an Outlook Calendar' href='#{purchase_total.icalLink()}'><img alt='' src='//images.bookingbug.com/widget/outlook.png'></a>
        <a class='image img_ical' title='Add this booking to an iCal Calendar' href='#{purchase_total.webcalLink()}'><img alt='' src='//images.bookingbug.com/widget/ical.png'></a>
        <a class='image img_gcal' title='Add this booking to Google Calendar' href='#{purchase_total.gcalLink()}' target='_blank'><img src='//images.bookingbug.com/widget/gcal.png' border='0'></a>
      "
