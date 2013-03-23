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
# schema-boot.coffee
#


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

Encapsule.code.app.bootDelay = 500

Encapsule.code.app.bootChromes = {
    phase0 : { title: "power", backgroundColor: "white" }
    phase1 : { title: "boot", backgroundColor: undefined }
    phase2 : { title: "#{appPackagePublisher}", backgroundColor: undefined }
    phase2checking : { title: "#{appName} ping", backgroundColor: undefined }
    phase2downloading: { title: "#{appName} update", backgroundColor: undefined }
    phase2progress: { title: "#{appName} update ", backgroundColor: "#DDFFEE" }
    phase2error: { title: "#{appName} ERROR", backgroundColor: "#FFFF00" }
    phase2obsolete: { title: "#{appName} LOCKED", backgroundColor: "#FFCC00" }
    phase2offline: { title: "#{appName} v#{appVersion}", backgroundColor: "#E7E7E7" }
    phase2cached: { title: "#{appName} installed", backgroundColor: "#FFFFCC" }
    phase2noupdate: { title: "#{appName} v#{appVersion}", backgroundColor: "white" }
    phase2updateready: { title: "#{appName} updated", backgroundColor: "#FFFFCC" }
    phase2watchdog: { title: "#{appName} ?8|" }
    #phase2watchdogNoop: { title: "#{appName} v#{appVersion}" }
    #phase2watchdogAction: { title: "#{appName} ?>8!", backgroundColor: "#FFCC00" }
    phase3: { title: "#{appName} v#{appVersion}", backgroundColor: "white" }
    }

Encapsule.code.app.setBootChrome = (phase_, progress_) ->
    bootChrome = Encapsule.code.app.bootChromes[phase_]
    if not bootChrome? and not bootChrome
        return false
    if bootChrome.title? and bootChrome.title
        pageTitle = bootChrome.title
        if progress_? and progress_
            pageTitle += progress_
        document.title = pageTitle
    if bootChrome.backgroundColor? and bootChrome.backgroundColor
        $("body").css( { backgroundColor: bootChrome.backgroundColor } )


phase0 = (bootstrapperOptions_) ->
    # APP BOOT PHASE 0 : Draw the boot UI and install the in-page hash router
    #
    phase0Out = bootstrapperOptions_.phase0 = {}

    # Draw the boot UI
    # Initialize the debug console for this app instance
    # Confirm the visitor's browser identity and reject unsupported browsers.
    # If unsupported browser display browser help UI
    # If supported browser proceed silently and immediately to phase 2

    bodyJN = $("body")
    bodyJN.html($("""
        <div id="idSpinner" class="classCentered"></div><div id="idConsole"></div>
        """))

    phase0Out = bootstrapperOptions_.phase0 = {}
    phase0Out.spinner = new Encapsule.code.lib.view.spinner()
    phase0Out.spinner.draw()

    Encapsule.code.app.setBootChrome("phase0")

    Console.init()
    Console.messageRaw("""
        <div id="idPreBootMessage">
            <h3>This single-page HTML 5 app requires a modern browser!</h3>
            <p>If you encounter problems during app boot, please ensure you're using the latest version of one of the following browsers:</p>
            <ul>
                <li><a href="https://www.google.com/intl/en/chrome/browser/" title="Install Chrome">Google Chrome</a></li>
                <li><a href="http://www.apple.com/safari/" title="Install Safari">Apple Safari</a></li>
                <li><a href="http://www.mozilla.org/en-US/" title="Install Firefox">Mozilla Firefox</a></li>
                <li><a href="http://windows.microsoft.com/en-us/internet-explorer/downloads/ie-10/worldwide-languages" title="Install Microsoft IE 10">Microsoft IE 10</a></li>
            </ul>
        </div>
        <h3>BOOTSTRAP PHASE 0 : establish local URI routing</h3>
        """)
    Console.log "#{appPackagePublisher} #{appName} v#{appVersion} #{appReleaseName} :: #{appPackageId}"
    Console.log "#{appName}: #{appBuildTime} by #{appBuilder} :: Thanks for using #{appName}. #{appPackagePublisherUrl}"

    phase0Out.router = new Encapsule.code.lib.router()
    bootstrapperOptions = bootstrapperOptions_

    phase0Out.router.setApplicationRouteCallback( (router_) ->
        phase1(bootstrapperOptions)
        )

phase1 = (bootstrapperOptions_) ->
    # APP BOOT PHASE 1 : Supported browser
    #

    phase1Out = bootstrapperOptions_.phase1 = {}
    phase1Out.userAgent = userAgent = navigator.userAgent
    browser = $.browser
    phase1Out.isChrome = isChrome = browser? and browser and browser.chrome? and browser.chrome or false
    phase1Out.isWebKit = isWebKit = browser? and browser and browser.webkit? and browser.webkit or false
    phase1Out.browserVersion = browserVersion = browser? and browser and browser.version? and browser.version or "unknown"

    Encapsule.code.app.setBootChrome("phase1")

    Console.messageRaw("<h3>BOOTSTRAP PHASE 1 : browser check</h3>")

    Console.message("Your browser purports to be a \"<strong>#{userAgent}</strong>\"")
    Console.message("isChrome=#{isChrome} isWebKit=#{isWebKit} browserVersion=#{browserVersion}")
    if isChrome
        Console.message("Your chrome shines brightly.")
    if isWebKit
        Console.message("WebKit browsers please us.")
    else
        Console.message("We note you're not running Chrome or another WebKit-based browser.")
        Console.message("This might work out for you (e.g. Firefox). Most IE users are SOL.")

    # Here's where we could bail and abort the bootstrap. For now we're just
    # pass through.

    bootstrapperOptions = bootstrapperOptions_
    setTimeout( ( -> phase2(bootstrapperOptions_) ), 150)

phase2 = (bootstrapperOptions_) ->
    Console.messageRaw("<h3>BOOTSTRAP PHASE 2 : offline application cache</h3>")

    # APP BOOT PHASE 2 : Application cache monitor
    #
    # Instantiate application cache monitor to hook application cache events.
    # 
    # We expect one of the following sequences of application cache events to occur:
    #

    phase2Out = bootstrapperOptions_.phase2 = {}
    phase2Out.appCacheMonitorState = "initializing"
    phase2Out.appCacheTerminalState = undefined

    Encapsule.code.app.setBootChrome("phase2")

    # Note to self: This entire subsystem will be completely redesigned using Schema v1.0.
    Console.message("Checking #{appPackagePublisher} origin server for #{appName} vNext...")

    appCacheCallbacks = {
        onChecking: ->
            Encapsule.code.app.setBootChrome("phase2checking")
        , onDownloading: ->
            Encapsule.code.app.setBootChrome("phase2downloading")
            Console.messageEnd("<strong>Updating</strong>")
            Console.messageStart("files ")
        , onProgress: (fileCount_) ->
            completionPercent = Math.min( Math.floor( (fileCount_ / appBuildCacheFileCount) * 100), 100)
            Encapsule.code.app.setBootChrome("phase2progress", "#{completionPercent}%")
            Console.messageRaw(".")
        , onError: ->
            Encapsule.code.app.setBootChrome("phase2error")
            phase2Out.appCacheMonitorState = "error"
            phase2Out.appCacheTerminalState = "error"
            Console.messageEnd(" <strong>OH SNAP!</strong>")
            Console.messageRaw("<h2>attention please</h2>")
            Console.messageRaw("<p>There has been a disturbance in the force.</p>")
            Console.messageRaw("<p>Please refresh this page to try try again.</p>")
            Console.messageError "An error has occurred caching application files from the #{appPackagePublisher}'s servers."
            throw "Manually refresh your browser to resolve. See log messages above for additional information."
        , onObsolete: ->
            Encapsule.code.app.setBootChrome("phase2obsolete")
            phase2Out.appCacheMonitorState = "locked (obsolete)"
            phase2Out.appCacheTerminalState = "locked (obsolete)"
            Console.messageEnd(" <strong>APP CACHE OBSOLETED</strong>")
            Console.messageRaw("<h2>OH SNAP!</h2>")
            Console.messageRaw("<p>We're sorry to inconvience you!</p>")
            Console.messageRaw("<p>Encapsule Project has issued a service advisory for #{appName} v#{appVersion} build ID #{appBuildId} and temporarily suspended service.</p>")
            Console.messageRaw("<p>Please visit <a href=\"#{appBlogUrl}\" title=\"#{appBlogName}\">#{appBlogName}</a> for the news and advisories.</p>")
            Console.messageError "#{appName} has been locked by Encpausle Project."
        , onOffline: ->
            Encapsule.code.app.setBootChrome("phase2offline")
            phase2Out.appCacheMonitorState = "offline"
            phase2Out.appCacheTerminalState = "locked (obsolete)"
            Console.messageEnd("<strong>OFFLINE</strong>");
            Console.message("Origin server is unreachable. Please try again later.")
            Console.messageRaw("<h2>#{appPackagePublisher} running offline from cache :)</h2>")
            setTimeout( ( -> phase3(bootstrapperOptions_) ), Encapsule.code.app.bootDelay)
        , onCached: (fileCount_) ->
            Encapsule.code.app.setBootChrome("phase2cached")
            phase2Out.appCacheMonitorState = "cached"
            phase2Out.appCacheTerminalState = "cached"
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.message("<strong>The application has been installed!</strong>")
            Console.messageRaw("<h2>#{appName} v#{appVersion} is now fully cached for on/offline use :)</h2>")
            setTimeout ( ->
                phase3(bootstrapperOptions_) )
                , Encapsule.code.app.bootDelay
        , onNoUpdate: ->
            Encapsule.code.app.setBootChrome("phase2noupdate")
            phase2Out.appCacheMonitorState = "noupdate"
            phase2Out.appCacheTerminalState = "noupdate"
            Console.messageEnd("<strong>No update<strong>")
            Console.messageRaw("<h2>#{appName} v#{appVersion} is good to go :-)</h2>")
            setTimeout( ( -> phase3(bootstrapperOptions_) ), Encapsule.code.app.bootDelay)
        , onUpdateReady: (fileCount_) ->
            Encapsule.code.app.setBootChrome("phase2updateready")
            phase2Out.appCacheMonitorState = "updateready"
            phase2Out.appCacheTerminalState = "updateready"
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.messageRaw("<h2>#{appName} has been updated :) Booting #{appName} vNext...</h2>")
            Console.message("What could go wrong?")
            setTimeout ( ->
                try
                    window.applicationCache.swapCache()
                    window.location.reload(true) # --> in theory, we're bye bye at this point -->
                catch exception
                    Encapsule.code.app.setBootChrome("phase2watchdog")
                    Console.message("Well that's interesting... While attempting to swap in the newly updated application cache we caught an unexpected exception.")
                    Console.message("I _believe_ this is exceptionally rare and occurs only when the app has previously been cached from a FQ path (e.g. http://schema.encapsule.org/schema.html) and is then accessed via a non-qualified URL (e.g. http://schema.encapsule.org).")
                    Console.messageRaw("<p>If you encounter this error under different circumstances please let me know.</p>")
                    Console.messageRaw("<p><strong>Note: you can typically recover from a DOM exception in this case by simply refreshing the page.</strong></p>")
                    Console.messageError(exception)
                ) , Encapsule.code.app.bootDelay
        }
    try
        phase2Out.appCacheMonitor = new Encapsule.code.lib.appcachemonitor(appCacheCallbacks)

        # I don't any way to actually detect if the cache has been updated before the event listeners are registered.
        # There simply isn't enough information available from the applicationCache object to determine what's happened
        # already.
        # Let's say that if none of our monitoring callbacks are invoked within two seconds that AND the reported cache
        # status is IDLE that we missed the show and everything is set to go.
        setTimeout( ( ->

            Encapsule.code.app.setBootChrome("phase2Watchdog")
            applicationCacheStatus = window.applicationCache.status
            applicationCacheMonitorState = phase2Out.appCacheMonitorState
            applicationCacheMonitorTerminalState = phase2Out.appCacheTerminalState

            switch applicationCacheStatus
                when window.applicationCache.UNCACHED
                    Encapsule.code.app.setBootChrome("phase2watchdogAction")
                    Console.messageError("Browser cache status is UNCACHED.")
                    break;

                when window.applicationCache.IDLE
                    if not applicationCacheMonitorTerminalState? or not applicationCacheMonitorTerminalState
                        Encapsule.code.app.setBootChrome("phase2watchdogAction")
                        phase2Out.appCacheRaceConditionBroken = true
                        appCacheCallbacks.onNoUpdate()
                    else
                        Encapsule.code.app.setBootChrome("phase2watchdogNoop")

                     
                when window.applicationCache.CHECKING
                    Encapsule.code.app.setBootChrome("phase2watchdogNoop")
                    break;

                when window.applicationCache.DOWNLOADING
                    Encapsule.code.app.setBootChrome("phase2watchdogNoop")
                    break;

                when window.applicationCache.UPDATEREADY
                     if not applicationCacheMonitorTerminalState? or not applicationCacheMonitorTerminalState
                        Encapsule.code.app.setBootChrome("phase2watchdogAction")
                        phase2Out.appCacheRaceConditionBroken = true
                        appCacheCallbacks.onUpdateReady()
                     else
                        Encapsule.code.app.setBootChrome("phase2watchdogNoop")
                   
                when window.applicationCache.OBSOLETE
                     Encapsule.code.app.setBootChrome("phase2watchdogNoop")
                     break;

            ), 500)
    catch exception
        Console.messageError(exception)


phase3 = (bootstrapperOptions_) ->

    Console.messageRaw("<h3>BOOTSTRAP PHASE 3 : online status monitoring</h3>")

    bootstrapperOptions_.phase2.appCacheMonitor.stop()   

    phase3Out = bootstrapperOptions_.phase3 = {}
    phase3Out.originServerOnline = false
    blipper = phase3Out.blipper = Encapsule.code.lib.audio.theme.create($("body"))

    Encapsule.code.app.setBootChrome("phase3")

    checkOnlineOptions = {
        timeout: 5000,
        pingRelative: true,
        pingFilePrefix: "no-cache/json/client-ping",
        #pingArgs: "?appBuildId=#{appBuildId}&pingTime=#{Encapsule.util.getEpochTime()}"
        }

    checkOnlineFunction = ( ->

        checkOnline ((statusIn_) -> 
            phase3Out.originServerOnline = statusIn_
            if statusIn_
                blipper.blip "xindi-on"
                Console.messageRaw """
                    <p>
                        #{appName} online check #{Date()}: <strong>ONLINE</strong><br>
                        ... #{appPackagePublisherUrl}/#{checkOnlineOptions.pingFilePrefix} was retrieved.
                    </p>"""
            else
                blipper.blip "xindi-off"
                Console.messageRaw """
                    <p>
                        #{appName} online check #{Date()}: <strong>ONLINE</strong><br>
                        ... #{appPackagePublisherUrl}/#{checkOnlineOptions.pingFilePrefix} could not be retrieved.
                    </p>"""

            ), checkOnlineOptions
        )

    Console.message("Checking online status.")
    checkOnlineFunction()
    onlineCheckPeriodMs = 10 * 60 * 1000
    Console.message("Online status will be checked periodically every #{onlineCheckPeriodMs / 60000} minutes.")
    setInterval ( -> checkOnlineFunction() ), onlineCheckPeriodMs

    # We're done with bootrapping?
    bootstrapperOptions_.exitStatus = "success"
    bootstrapperOptions_.onBootstrapComplete "Everything is going extremely well."    

class namespaceEncapsule_code_app.bootstrapper
    
    @run: (bootstrapperOptions_) ->
        if not bootstrapperOptions_? or not bootstrapperOptions_
            throw "You must specify a callback function to be called on success."
        @phase0(bootstrapperOptions_)

    @phase0: phase0
    @phase1: phase1
    @phase2: phase2
    @phase3: phase3



