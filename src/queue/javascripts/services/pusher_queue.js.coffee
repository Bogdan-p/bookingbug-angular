###**
* @ngdoc service
* @name BBQueue.Services:PusherQueue
*
* @description
* Factory PusherQueue
*
* @requires $sessionStorage
* @requires $pusher
* @requires AppConfig
*
* @returns {Promise} This service has the following set of methods:
*
* - subscribe(comapy)
*
###

angular.module('BBQueue.Services').factory 'PusherQueue', ($sessionStorage, $pusher, AppConfig) ->

  class PusherQueue

    ###**
    * @ngdoc method
    * @name this.subscribe
    * @methodOf BBQueue.Services:PusherQueue
    *
    * @description
    * Method this.subscribe
    *
    * @param {object} company company
    *
    * @returns {object} this.pusher.subscribe
    *
    ###

    @subscribe: (company) ->
      if company? && Pusher?
        unless @client?
          @client = new Pusher 'c8d8cea659cc46060608',
            authEndpoint: "/api/v1/push/#{company.id}/pusher.json"
            auth:
              headers:
                'App-Id' : AppConfig['App-Id']
                'App-Key' : AppConfig['App-Key']
                'Auth-Token' : $sessionStorage.getItem('auth_token')

        @pusher = $pusher(@client)
        @channel = @pusher.subscribe("mobile-queue-#{company.id}")

