###**
* @ngdoc service
* @name BBAdmin.Services:AdminBookingService
*
* @description
* <br> ---------------------------------------------------------------------------------
* <br> NOTE
* <br> This is the TEST file.
* <br> Formatting of the documentation for this kind of functionality should be done first here
* <br> !To avoid repetition and to mentain consistency.
* <br> After the documentation for TEST file it is defined other files that have the same pattern can be also documented
* <br> This should be the file that sets the STANDARD.
* <br> ---------------------------------------------------------------------------------<br><br>
* Factory AdminBookingService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {object} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window read more}
*
* @param {model} BookingCollections Info
*
* @param {model} halClient Info
*
* @param {service} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {constant} UriTemplate Info
* <br>
* {@link UriTemplate more}
*
###
angular.module('BBAdmin.Services').factory 'AdminBookingService', ($q, $window,
    halClient, BookingCollections, BBModel, UriTemplate) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method query
  *
  * @param {Promise} prms Info
  *
  * @returns {Promise} deferred.promise
  ###
  query: (prms) ->
    if prms.slot
      prms.slot_id = prms.slot.id
    if prms.date
      prms.start_date = prms.date
      prms.end_date = prms.date

    prms.per_page = 1024 if !prms.per_page?
    prms.include_cancelled = false if !prms.include_cancelled?

    deferred = $q.defer()
    existing = BookingCollections.find(prms)
    if existing
      deferred.resolve(existing)
    else if prms.company
      prms.company.$get('bookings', prms).then (collection) ->
        collection.$get('bookings').then (bookings) ->
          models = (new BBModel.Admin.Booking(b) for b in bookings)
          deferred.resolve(models)
        , (err) ->
          deferred.reject(err)
      , (err) ->
        deferred.reject(err)
    else
      url = ""
      url = prms.url if prms.url
      href = url + "/api/v1/admin/{company_id}/bookings{?slot_id,start_date,end_date,service_id,resource_id,person_id,page,per_page,include_cancelled}"
      uri = new UriTemplate(href).fillFromObject(prms || {})

      halClient.$get(uri, {}).then  (found) =>
        found.$get('bookings').then (items) =>
          sitems = []
          for item in items
            sitems.push(new BBModel.Admin.Booking(item))
          spaces = new $window.Collection.Booking(found, sitems, prms)
          BookingCollections.add(spaces)
          deferred.resolve(spaces)
      , (err) =>
        deferred.reject(err)

    deferred.promise

  ###**
  * @ngdoc method
  * @name getBooking
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method getBooking.
  *
  * If a company exists and don't have an id it gets one
  * <pre>
  * if prms.company && !prms.company_id prms.company_id = prms.company.id
  * </pre>
  *
  * Gets the href for boogking
  * <pre>
  * href = "/api/v1/admin/{company_id}/bookings/{id}{?embed}"
  * </pre>
  *
  * Is created a new uri
  * <pre>
  * uri = new UriTemplate(href).fillFromObject(prms || {})
  * </pre>
  *
  * If the promise is resolved
  * <pre>
  * deferred.resolve(booking)
  * </pre>
  *
  * If the promise is rejected it displays an error
  * <pre>
  * deferred.reject(err)
  * </pre>
  *
  * Newly created deferred object return its promise property
  * <pre>
  * deferred.promise
  * </pre>
  *
  * @param {Promise} prms Info
  *
  * @returns {Promise} deferred.promise
  ###
  getBooking: (prms) ->
    deferred = $q.defer()
    if prms.company && !prms.company_id
      prms.company_id = prms.company.id
    href = "/api/v1/admin/{company_id}/bookings/{id}{?embed}"
    uri = new UriTemplate(href).fillFromObject(prms || {})
    halClient.$get(uri, { no_cache: true }).then (item) ->
      booking  = new BBModel.Admin.Booking(item)
      BookingCollections.checkItems(booking)
      deferred.resolve(booking)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name cancelBooking
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method cancelBooking
  *
  * It creates a new deferred object, then return its promise property.
  * <pre>
  * deferred = $q.defer()
  * </pre>
  *
  * Gets the href for boogking
  * <pre>
  * href = "/api/v1/admin/{company_id}/bookings/{id}?notify={notify}"
  * </pre>
  *
  * Is created a new uri
  * <pre>
  * uri = new UriTemplate(href).fillFromObject(prms || {})
  * </pre>
  *
  * If the promise is resolved the booking is canceled
  * <pre>
  * deferred.resolve(booking)
  * </pre>
  *
  * If the promise is rejected it displays an error
  * <pre>
  * deferred.reject(err)
  * </pre>
  *
  * Newly created deferred object return its promise property
  * <pre>
  * deferred.promise
  * </pre>
  *
  * @param {Promise} prms Info
  *
  * @param {object} booking Info
  *
  * @returns {Promise} deferred.promise
  ###
  cancelBooking: (prms, booking) ->
    deferred = $q.defer()
    href = "/api/v1/admin/{company_id}/bookings/{id}?notify={notify}"
    prms.id ?= booking.id

    notify = prms.notify
    notify ?= true

    uri = new UriTemplate(href).fillFromObject(prms || {})
    halClient.$del(uri, { notify: notify }).then (item) ->
      booking = new BBModel.Admin.Booking(item)
      BookingCollections.checkItems(booking)
      deferred.resolve(booking)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name updateBooking
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method updateBooking
  *
  * It creates a new deferred object, then return its promise property.
  * <pre>
  * deferred = $q.defer()
  * </pre>
  *
  * Gets the href for boogking
  * <pre>
  * href = "/api/v1/admin/{company_id}/bookings/{id}"
  * </pre>
  *
  * Is created a new uri
  * <pre>
  * uri = new UriTemplate(href).fillFromObject(prms || {})
  * </pre>
  *
  * If the promise is resolved the booking is updated
  * <pre>
  * deferred.resolve(booking)
  * </pre>
  *
  * If the promise is rejected it displays an error
  * <pre>
  * deferred.reject(err)
  * </pre>
  *
  * Newly created deferred object return its promise property
  * <pre>
  * deferred.promise
  * </pre>
  *
  * @param {Promise} prms Info
  *
  * @param {object} booking Info
  *
  * @returns {Promise} deferred.promise
  ###
  updateBooking: (prms, booking) ->
    deferred = $q.defer()
    href = "/api/v1/admin/{company_id}/bookings/{id}"
    prms.id ?= booking.id

    uri = new UriTemplate(href).fillFromObject(prms || {})
    halClient.$put(uri, {}, prms).then (item) ->
      booking = new BBModel.Admin.Booking(item)
      BookingCollections.checkItems(booking)
      deferred.resolve(booking)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name blockTimeForPerson
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method blockTimeForPerson
  *
  * It creates a new deferred object, then return its promise property.
  * <pre>
  * deferred = $q.defer()
  * </pre>
  *
  * Gets the href for boogking
  * <pre>
  * href = "/api/v1/admin/{company_id}/people/{person_id}/block"
  * </pre>
  *
  * Is created a new uri
  * <pre>
  * uri = new UriTemplate(href).fillFromObject(prms || {})
  * </pre>
  *
  * halClien.$put
  * <br>
  * It creates a new Booking Model for Admin in BBmodel module
  * <pre>
  * uri = new UriTemplate(href).fillFromObject(prms || {})
  * </pre>
  *
  * If the promise is resolved the booking is updated
  * <pre>
  * deferred.resolve(booking)
  * </pre>
  *
  * If the promise is rejected it displays an error
  * <pre>
  * deferred.reject(err)
  * </pre>
  *
  * Newly created deferred object return its promise property
  * <pre>
  * deferred.promise
  * </pre>
  *
  * @param {Promise} prms Info
  *
  * @param {object} person Info
  *
  * @returns {Promise} deferred.promise
  ###
  blockTimeForPerson: (prms, person) ->
    deferred = $q.defer()
    href = "/api/v1/admin/{company_id}/people/{person_id}/block"
    prms.person_id ?= person.id
    prms.booking = true
    uri = new UriTemplate(href).fillFromObject(prms || {})
    halClient.$put(uri, {}, prms).then (item) ->
      booking = new BBModel.Admin.Booking(item)
      BookingCollections.checkItems(booking)
      deferred.resolve(booking)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name addStatusToBooking
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method addStatusToBooking
  *
  * @param {Promise} prms Info
  * @param {object} booking Info
  * @param {String} status Info
  *
  * @returns {Promise} deferred.promise
  ###
  addStatusToBooking: (prms, booking, status) ->
    deferred = $q.defer()
    href = "/api/v1/admin/{company_id}/bookings/{booking_id}/multi_status"
    prms.booking_id ?= booking.id
    uri = new UriTemplate(href).fillFromObject(prms || {})
    halClient.$put(uri, {}, { status: status }).then (item) ->
      booking  = new BBModel.Admin.Booking(item)
      BookingCollections.checkItems(booking)
      deferred.resolve(booking)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name addPrivateNoteToBooking
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method addPrivateNoteToBooking
  *
  * @param {Promise} prms Info
  * @param {object} booking Info
  * @param {object} note Info
  *
  * @returns {Promise} deferred.promise
  ###
  addPrivateNoteToBooking: (prms, booking, note) ->
    deferred = $q.defer()
    href = "/api/v1/admin/{company_id}/bookings/{booking_id}/private_notes"
    prms.booking_id ?= booking.id

    noteParam = note.note if note.note?
    noteParam ?= note

    uri = new UriTemplate(href).fillFromObject(prms || {})
    halClient.$put(uri, {}, { note: noteParam }).then (item) ->
      booking  = new BBModel.Admin.Booking(item)
      BookingCollections.checkItems(booking)
      deferred.resolve(booking)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name updatePrivateNoteForBooking
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method updatePrivateNoteForBooking
  *
  * @param {Promise} prms Info
  * @param {object} booking Info
  * @param {object} note Info
  *
  * @returns {Promise} deferred.promise
  ###
  updatePrivateNoteForBooking: (prms, booking, note) ->
    deferred = $q.defer()
    href = "/api/v1/admin/{company_id}/bookings/{booking_id}/private_notes/{id}"
    prms.booking_id ?= booking.id
    prms.id ?= note.id

    uri = new UriTemplate(href).fillFromObject(prms || {})
    halClient.$put(uri, {}, { note: note.note }).then (item) ->
      booking  = new BBModel.Admin.Booking(item)
      BookingCollections.checkItems(booking)
      deferred.resolve(booking)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  ###**
  * @ngdoc method
  * @name deletePrivateNoteFromBooking
  * @methodOf BBAdmin.Services:AdminBookingService
  *
  * @description
  * Method deletePrivateNoteFromBooking
  *
  * @param {Promise} prms Info
  * @param {object} booking Info
  * @param {object} note Info
  *
  * @returns {Promise} deferred.promise
  ###
  deletePrivateNoteFromBooking: (prms, booking, note) ->
    deferred = $q.defer()
    href = "/api/v1/admin/{company_id}/bookings/{booking_id}/private_notes/{id}"
    prms.booking_id ?= booking.id
    prms.id ?= note.id

    uri = new UriTemplate(href).fillFromObject(prms || {})
    halClient.$del(uri, {}).then (item) ->
      booking  = new BBModel.Admin.Booking(item)
      BookingCollections.checkItems(booking)
      deferred.resolve(booking)
    , (err) =>
      deferred.reject(err)
    deferred.promise
