###

  http://schema.encapsule.org/schema.html

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapsule-appcache-monitor.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encpasule.code or @Encapusle.code = {}
namespaceEncapsule_code_lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}


class namespaceEncapsule_code_lib.appcachemonitor
 
    appCallbacks: undefined
    status: undefined
    error: undefined
    fileCount: 0
     
    onChecking: =>
        @status = "checking"
        @appCallbacks.onChecking()
    onDownloading: =>
        @status = "downloading"
        @appCallbacks.onDownloading()
    onProgress: =>
        @fileCount++
        @appCallbacks.onProgress(@fileCount)
    onError: =>
        if @status == "downloading"
            @status = "error"
            @appCallbacks.onError()
        else
            @status = "offline"
            @appCallbacks.onOffline()
    onObsolete: =>
        @status = "obsolete"
        @appCallbacks.onObsolete()
    onCached: =>
        @status = "cached"
        @appCallbacks.onCached(@fileCount)
    onNoUpdate: =>
        @status = "noupdate"
        @appCallbacks.onNoUpdate()
    onUpdateReady: =>
        @status = "updateready"
        @appCallbacks.onUpdateReady(@fileCount)

    constructor: (callbacks_) ->
        @status = "initializing"
        if not (callbacks_? and callbacks_)
            @status = "failed"
            @error = "You must specifiy a callbacks object."
            throw @error

        @appCallbacks = callbacks_

        cache = window.applicationCache
        if not (cache? and cache)
            @status = "failed"
            @error = "Your browser does not appear to support HTML5 application cache."
            throw @error

        @status = "hookingEvents"

        try
            #
            # Reference: http://www.whatwg.org/specs/web-apps/current-work/#applicationcache
            #

            # MONITOR INITIAL STATE

            #
            # When a visitor first navigates to the application page, or manually
            # refreshes the page via their browser the registered onChecking callback
            # is called.
            #
            # Following onChecking, the "monitor" transitions to one of several terminal
            # states, or to an intermediate state. Connectivity to the origin server, 
            # prior exisitence of an application cache for this app, and the existence
            # of an update from the origin server all factor into which transition is
            # made as explained in comments below.
            #
            cache.addEventListener "checking", @onChecking, false
   
            # MONITOR INTERMEDIATE STATES

            #
            # Provided that the browser can connect to the origin server to fetch the app
            # cache manifest, onDownloading is called following onChecking to indicate that
            # the browser is refreshing the contents of the application cache.
            #
            # There is a distinction between first-time install and an update of the app
            # cache which may, for example, be useful for determining specific actions to
            # take in downstream application code. onDownload gets called regardless of
            # if first-time installation or update however.
            #
            # After the application cache has been updated, the reason why the cache was
            # updated is communicated by which of several terminal states the monitor
            # transitions to.
            #
            cache.addEventListener "downloading", @onDownloading, false

            # Following an onDownloading callback, onProgress will be called once for
            # every resource downloaded and stored in the application cache. If there's
            # a way to get additional about the downloaded item I haven't figured it out
            # yet so this is just an opaque callback.
            #
            cache.addEventListener "progress", @onProgress, false

            # MONITOR TERMINAL STATES

            #
            # onError is called if the browser cannot establish communication with the
            # origin server to check the app cache manifest or download resources. onError
            # might also be called if communication with the origin server is interrupted
            # while the browser is in the process of refreshing the application cache.
            #
            # Typically onError will be called because the visitor has browsed to the
            # application's URL while offline. The app, loading from the app cache, attempts
            # to contact the origin server to check for an updated app cache manifest but
            # cannot and onError is called. In this case, application logic typically ignores
            # the onError callback treating the event as though it was an onNoUpdate.
            #
            # In the unlikely event that onError is called following onDownloading or onProgress
            # then the connection has been interrupted and the browser discard whatever it
            # managed to download before the disruption.
            #
            # To make this a bit more useful, this library adds a virtual "onOffline" event
            # that the caller must register a callback for. If the actual onError event fires
            # from the app cache, we dispatch to onOffline iff the last event fired was
            # onChecking. Otherwise, the real onError fired after onDownloading or onProgress
            # and indicates a service disruption as above and we dispatch to the caller's
            # registered onError handler as expected.
            #
            cache.addEventListener "error", @onError, false

            # onObsolete is called if the request to retrieve the app cache manifest file from
            # the server returned an HTTP status 404 or 408 code. In the case of a 404 it's likely
            # that the deployed application image on the server is being updated. In the case of a
            # 408, it's likely that the server is temporarily overloaded. In either case the 
            #
            cache.addEventListener "obsolete", @onObsolete, false

            #
            # "onOffline" is a "virtual" event supported by the AppCacheMonitor. It is actually
            # derived from cache.onError as explained above and is not actually added as an event
            # to the cache object.
            #

            #
            # onCached is called after the browser has completed its first update of the app cache.
            # Application logic dependent on local storage will typically create and initialize their
            # local stores in response to this event.
            #
            cache.addEventListener "cached", @onCached, false

            #
            # onNoUpdate is called after onChecking to indicate that the existing app cache is up-to-date.
            #
            cache.addEventListener "noupdate", @onNoUpdate, false
            cache.addEventListener "updateready", @onUpdateReady, false

        catch exception
            # All the callback functions must be specified callbacks_. Perhaps you missed one?
            @status = "failed"
            @error = exception
            throw @error

        @status = "waiting"


    stop: ->
        cache = window.applicationCache
        if not (cache? and cache)
            @status = "failed"
            @error = "Your browser does not appear to support HTML5 application cache."
            throw @error
        try
            cache.removeEventListener "checking",  @onChecking
            cache.removeEventListener "downloading", @onDownloading
            cache.removeEventListener "progress", @onProgress
            cache.removeEventListener "error", @onError
            cache.removeEventListener "obsolete", @onObsolete
            cache.removeEventListener "cached", @onCached
            cache.removeEventListener "noupdate", @onNoUpdate
            cache.removeEventListener "updateready", @onUpdateReady
            @status = "stopped"
        catch exception
            throw "In stopAppCacheMonitor #{exception}"





