###**
* @ngdoc service
* @name  BBAdmin.Services:AdminSlotService
*
* @description
* Factory AdminSlotService
*
* @param {service} $q A service that helps you run functions asynchronously, and use their return values (or exceptions) when they are done processing.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$q read more}
*
* @param {object} $window A reference to the browser's window object.
* <br>
* {@link https://docs.angularjs.org/api/ng/service/$window read more}
*
* @param {model} halClient Info
*
* @param {model} SlotCollections Info
*
* @param {model} BBModel Info
* <br>
* {@link BB.Models:BBModel more}
*
* @param {model} UriTemplate Info
* <br>
* {@link UriTemplate more}
*
###
angular.module('BBAdmin.Services').factory 'AdminSlotService', ($q, $window,
    halClient, SlotCollections, BBModel, UriTemplate) ->

  ###**
  * @ngdoc method
  * @name query
  * @methodOf BBAdmin.Services:AdminSlotService
  *
  * @description
  * Method query
  *
  * @param {object} prms Info
  *
  * @returns {Promise} defer.reject(err) or deferred.promise
  ###
  query: (prms) ->
    deferred = $q.defer()

    # see if a colection of slots matching this quesry is already being monitored
    existing = SlotCollections.find(prms)
    if existing
      deferred.resolve(existing)
    else if prms.user
      prms.user.$get('company').then (company) ->
        company.$get('slots', prms).then (slots_collection) ->
          slots_collection.$get('slots').then (slots) ->
            slot_models = (new BBModel.Admin.Slot(s) for s in slots)
            deferred.resolve(slot_models)
          , (err) ->
            deferred.reject(err)
    else
      url = ""
      url = prms.url if prms.url
      href = url + "/api/v1/admin/{company_id}/slots{?start_date,end_date,date,service_id,resource_id,person_id,page,per_page}"
      uri = new UriTemplate(href).fillFromObject(prms || {})

      halClient.$get(uri, {}).then  (found) =>
        found.$get('slots').then (items) =>
          sitems = []
          for item in items
            sitems.push(new BBModel.Admin.Slot(item))
          slots  = new $window.Collection.Slot(found, sitems, prms)
          SlotCollections.add(slots)
          deferred.resolve(slots)
      , (err) =>
        deferred.reject(err)

    deferred.promise

  ###**
  * @ngdoc method
  * @name create
  * @methodOf BBAdmin.Services:AdminSlotService
  *
  * @description
  * Method create
  *
  * @param {object} prms Info
  *
  * @param {object} data Info
  *
  * @returns {Promise} deferred.reject(err) or deferred.promise
  ###
  create: (prms, data) ->

    url = ""
    url = prms.url if prms.url
    href = url + "/api/v1/admin/{company_id}/slots"
    uri = new UriTemplate(href).fillFromObject(prms || {})

    deferred = $q.defer()

    halClient.$post(uri, {}, data).then  (slot) =>
      slot = new BBModel.Admin.Slot(slot)
      SlotCollections.checkItems(slot)
      deferred.resolve(slot)
    , (err) =>
      deferred.reject(err)

    deferred.promise

  ###**
  * @ngdoc method
  * @name delete
  * @methodOf BBAdmin.Services:AdminSlotService
  *
  * @description
  * Method delete
  *
  * @param {object} item Info
  *
  * @returns {Promise} deferred.reject(err) or deferred.promise
  ###
  delete: (item) ->

    deferred = $q.defer()
    item.$del('self').then  (slot) =>
      slot = new BBModel.Admin.Slot(slot)
      SlotCollections.deleteItems(slot)
      deferred.resolve(slot)
    , (err) =>
      deferred.reject(err)

    deferred.promise

  ###**
  * @ngdoc method
  * @name update
  * @methodOf BBAdmin.Services:AdminSlotService
  *
  * @description
  * Method update
  *
  * @param {object} item Info
  *
  * @param {object} data Info
  *
  * @returns {Promise} deferred.reject(err) or deferred.promise
  ###
  update: (item, data) ->

    deferred = $q.defer()
    item.$put('self', {}, data).then  (slot) =>
      slot = new BBModel.Admin.Slot(slot)
      SlotCollections.checkItems(slot)
      deferred.resolve(slot)
    , (err) =>
      deferred.reject(err)

    deferred.promise
