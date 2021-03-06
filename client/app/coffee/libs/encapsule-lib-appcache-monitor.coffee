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
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}

backchannel = Encapsule.runtime.backchannel? and Encapsule.runtime.backchannel or throw "Missing expected Encapsule.runtime.backchannel object."

class Encapsule.code.lib.ApplicationCacheMonitor
 
    appCallbacks: undefined
    status: undefined
    error: undefined
    fileCount: 0

    onChecking: =>
        backchannel.log("Encapsule application cache monitor: CHECKING event handler.")
        @status = "checking"
        @appCallbacks.onChecking()
    onDownloading: =>
        backchannel.log("Encapsule application cache monitor: DOWNLOADING event handler.")
        @status = "downloading"
        @appCallbacks.onDownloading()
    onProgress: =>
        backchannel.log("Encapsule application cache monitor: PROGRESS event handler.")
        @status = "downloading"
        @fileCount++
        @appCallbacks.onProgress(@fileCount)
    onError: =>
        # Terminal state
        backchannel.log("Encapsule application cache monitor: ERROR event handler.")
        @stop()
        switch @cache.status
            when window.applicationCache.UNCACHED
                backchannel.log("... Error event called with browser app cache in UNCACHED state. Calling app's OBSOLETE handler.")
                @appCallbacks.onObsolete()
                break;
            when window.applicationCache.IDLE
                backchannel.log("... Error event called with browser app cache in IDLE state. Calling app's OFFLINE handler.")
                @appCallbacks.onOffline()
                break;
            when window.applicationCache.CHECKING
                backchannel.log("... Error event called with browser app cache in CHECKING state. Calling app's ERROR handler")
                break;
            when window.applicationCache.DOWNLOADING
                backchannel.log("... Error event called with browser app cache in CHECKING state. Calling app's ERROR handler")
                break;
            else
                backchannel.error("Encapsule application cache monitor unexpected browser app cache state found in error handler callback!")

    onObsolete: =>
        # Terminal state
        backchannel.log("Encapsule application cache monitor: OBSOLETE event handler.")
        @stop()
        @status = "obsolete"
        @appCallbacks.onObsolete()
    onCached: =>
        # Terminal state
        backchannel.log("Encapsule application cache monitor: CACHED event handler.")
        @stop()
        @status = "cached"
        @appCallbacks.onCached(@fileCount)
    onNoUpdate: =>
        # Terminal state
        backchannel.log("Encapsule application cache monitor: NOUPDATE event handler.")
        @stop()
        @status = "noupdate"
        @appCallbacks.onNoUpdate()
    onUpdateReady: =>
        # Terminal state
        backchannel.log("Encapsule application cache monitor: UPDATEREADY event handler.")
        @stop()
        @status = "updateready"
        @appCallbacks.onUpdateReady(@fileCount)

    constructor: (callbacks_) ->
        backchannel.log("Initializing Encapsule application cache monitor subsystem.")
        @status = "initializing"
        if not (callbacks_? and callbacks_)
            @status = "failed"
            @error = "You must specifiy a callbacks object."
            throw @error

        @appCallbacks = callbacks_

        @cache = window.applicationCache
        if not (@cache? and @cache)
            @status = "failed"
            @error = "Your browser does not appear to support HTML5 application cache."
            throw @error

        @initialAppCacheStatus = @cache.status
        @finalAppCacheStatus = undefined
        backchannel.log("... browser application initial status prior to event registration = #{@initialAppCacheStatus}")

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
            @cache.addEventListener "checking", @onChecking, false
   
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
            @cache.addEventListener "downloading", @onDownloading, false

            # Following an onDownloading callback, onProgress will be called once for
            # every resource downloaded and stored in the application cache. If there's
            # a way to get additional about the downloaded item I haven't figured it out
            # yet so this is just an opaque callback.
            #
            @cache.addEventListener "progress", @onProgress, false

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
            @cache.addEventListener "error", @onError, false

            # onObsolete is called if the request to retrieve the app cache manifest file from
            # the server returned an HTTP status 404 or 408 code. In the case of a 404 it's likely
            # that the deployed application image on the server is being updated. In the case of a
            # 408, it's likely that the server is temporarily overloaded. In either case the 
            #
            @cache.addEventListener "obsolete", @onObsolete, false

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
            @cache.addEventListener "cached", @onCached, false

            #
            # onNoUpdate is called after onChecking to indicate that the existing app cache is up-to-date.
            #
            @cache.addEventListener "noupdate", @onNoUpdate, false
            @cache.addEventListener "updateready", @onUpdateReady, false

        catch exception
            # All the callback functions must be specified callbacks_. Perhaps you missed one?
            @status = "failed"
            @error = exception
            throw @error

        @status = "waiting"

        @watchDogTimerElapsedTime = 0
        @watchDogTimerElapsedTimeActual = 0
        @watchDogTimerInterval = 2000
        @watchDogTimerDropDeadTimeout = 10000

        @watchDogTimer = setInterval( ( =>
            currentAppCacheStatus = @cache.status
            @watchDogTimerElapsedTime += @watchDogTimerInterval
            @watchDogTimerElapsedTimeActual += @watchDogTimerInterval
            backchannel.log("Encapsule application cache monitor watchdog: Elaped=#{@watchDogTimerElapsedTime} Current browser cache status=#{currentAppCacheStatus} Monitor status=#{@status}")

            # Give the browser a swift kick in the pants iff necessary.
            #
            # We have three pieces of data upon which to base a decision about what to do next:
            # - The original browser app cache status (@initialAppCacheStatus)
            # - The current browser app cache status (currentAppCacheStatus)
            # - The app cache monitor class status (@status (note this is a string))

            Encapsule.runtime.boot.phase0.blipper.blip "1526"
            if (@watchDogTimerElapsedTimeActual % 20000) == 0
                Encapsule.runtime.boot.phase0.blipper.blip "loading-profile"

            switch currentAppCacheStatus
                when window.applicationCache.UNCACHED
                    if @initialAppCacheStatus == window.applicationCache.UNCACHED
                        backchannel.log("... both initial and current browser app cache status is UNCACHED. Potentially, the application is LOCKED.")
                        if @status != "downloading"
                            @stop()
                            backchannel.log("""... the app cache monitor is not "downloading" so we're calling it LOCKED.""")
                            @appCallbacks.onObsolete()
                        else
                            backchannel.log("""... the app cache monitor is "downloading" so we'll continue to watch this.""")
                    else
                        backchannel.log("... browser app cache status has tranitioned to UNCACHED. This looks like a connection error.")
                        @stop()
                        @appCallbacks.onError()
                    break
                when window.applicationCache.IDLE
                    switch @initialAppCacheStatus
                        when window.applicationCache.UNCACHED
                            backchannel.log("... browser app cache status was initially UNCACHED but current status is IDLE. This looks like a fresh install.")
                            @stop()
                            @appCallbacks.onCached()
                            break
                        when window.applicationCache.IDLE
                            backchannel.log("... browser app cache status was initially IDLE and is still IDLE.")
                            if @status == "waiting"
                                backchannel.log("... monitor status is #{@status}. Assuming no update.")
                                @stop()
                                @appCallbacks.onNoUpdate()
                            else
                                backchannel.log("... monitor status is #{@status}. Continuing to watch...")
                            break
                        when window.applicationCache.CHECKING
                            backchannel.log("... browser app cache status was initially IDLE and is currently CHECKING. Continue to watch...")
                            break
                        when window.applicationCache.DOWNLOADING
                            backchannel.log("... the browser app cache status was initially IDLE and is currently DOWNLOADING.")
                            break
                        else
                            stop()
                            backchannel.error("Encapsule application cache monitor unable to reconcile current cache status. Giving up.")
                    break
                when window.applicationCache.CHECKING
                    backchannel.log("... browser app cache status is currently CHECKING. Continue to watch...")
                    break
                when window.applicationCache.DOWNLOADING
                    backchannel.log("... browser app cache status is currently DOWNLOADING. Continue to watch...")
                    break
                when window.applicationCache.UPDATEREADY
                    backchannel.log("... browser app cache status is currently UPDATEREADY.")
                    @stop()
                    @appCallbacks.onUpdateReady()
                    break
                when window.applicationCache.OBSOLETE
                    backchannel.log("... browser app cache status is currently OBSOLETE.")
                    @stop()
                    @appCallbacks.onObsolete()
                    break
                else
                   backchannel.error("Encapsule application cache monitor unexpected browser app cache state found in watchdog timer handler!")


            if @watchDogTimerElapsedTime >= @watchDogTimerDropDeadTimeout
                currentAppCacheStatus = @cache.status
                switch currentAppCacheStatus
                    when window.applicationCache.IDLE

                        @stop()

                        # We can allow the application to proceed because the cache status is IDLE.
                        # However, we are not clear based solely on the current cache status if we're
                        # offline, have determined there's no update available or taken an update.

                        switch @status
                            when "downloading"
                                backchannel.log("... the monitor detected DOWNLOADING activity but the browser hasn't fired events to signal completion. Assuming we took an update.")
                                @appCallbacks.onUpdateReady()
                                break

                            when "checking"
                                backchannel.log("... the monitor notes entry into CHECKING handler but the browser hasn't fired events to signal completion. Assuming no update.")
                                @appCallbacks.onNoUpdate()
                                break

                            else
                                backchannel.error("Application cache watchdog timer total elapsed time has exceeded drop-dead threshold! Giving up. Please try a manual page refresh.")
                                break;

                        break

                    when window.applicationCache.DOWNLOADING

                        switch @status
                            when "downloading"
                                backchannel.log("... the monitor detected DOWNLOADING activitity but it doesn't look like we've finished yet. Extending drop-dead time for another click.")
                                @watchDogTimerElapsedTime -= @watchDogTimerInterval
                                break
                            else
                                @stop()
                                backchannel.error("Application cache watchdog timer total elapsed time has exceeded drop-dead threshold! Giving up. Please try a manual page refresh.")
                                break;

            ), @watchDogTimerInterval)


    stop: =>
        try
            backchannel.log("Application cache monitor removing event handlers and terminating.")
            clearInterval(@watchDogTimer)
            @cache.removeEventListener "checking",  @onChecking
            @cache.removeEventListener "downloading", @onDownloading
            @cache.removeEventListener "progress", @onProgress
            @cache.removeEventListener "error", @onError
            @cache.removeEventListener "obsolete", @onObsolete
            @cache.removeEventListener "cached", @onCached
            @cache.removeEventListener "noupdate", @onNoUpdate
            @cache.removeEventListener "updateready", @onUpdateReady
            @finalAppCacheStatus = @cache.status
            backchannel.log("Application cache monitor has terminated. Final browser cache status=#{@finalAppCacheStatus}")
        catch exception
            throw "In stopAppCacheMonitor #{exception}"





