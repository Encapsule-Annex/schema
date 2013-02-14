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
namespaceCore = Encapsule.core? and Encapsule.core or @Encapsule.core = {}

phase1 = (bootstrapperOptions_, onPhaseComplete_) ->
    # APP BOOT PHASE 1 : Supported browser
    #
    # Draw the boot UI
    # Initialize the debug console for this app instance
    # Confirm the visitor's browser identity and reject unsupported browsers.
    # If unsupported browser display browser help UI
    # If supported browser proceed silently and immediately to phase 2

    bodyJN = $("body")
    bodyJN.html($("""<div id="idSpinner" class="classCentered"></div><div id="idConsole"></div>"""))

    phase1Out = bootstrapperOptions_.phase1 = {}
    phase1Out.spinner = new Encapsule.view.widget.spinner()
    phase1Out.spinner.draw()

    Console.init()
    Console.messageRaw("<h3>BOOTSTRAP PHASE 1</h3>")
    Console.log "#{appPackagePublisher} #{appName} v#{appVersion} #{appReleaseName} :: #{appPackageId}"
    Console.log "#{appName}: #{appBuildTime} by #{appBuilder} :: Thanks for using #{appName}. #{appPackagePublisherUrl}"

    phase1Out.userAgent = userAgent = navigator.userAgent
    browser = $.browser
    phase1Out.isChrome = isChrome = browser? and browser and browser.chrome? and browser.chrome or false
    phase1Out.isWebKit = isWebKit = browser? and browser and browser.webkit? and browser.webkit or false
    phase1Out.browserVersion = browserVersion = browser? and browser and browser.version? and browser.version or "unknown"

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

    #onPhaseComplete_()
    bootstrapperOptions = bootstrapperOptions_
    phase2(bootstrapperOptions)

phase2 = (bootstrapperOptions_) ->
    Console.messageRaw("<h3>BOOTSTRAP PHASE 2</h3>")

    # APP BOOT PHASE 2 : Application cache monitor
    #
    # Instantiate application cache monitor to hook application cache events.
    # 
    # We expect one of the following sequences of application cache events to occur:
    #

    phase2Out = bootstrapperOptions_.phase2 = {}
    phase2Out.appCacheMonitorState = "initializing"

    appCacheCallbacks = {
        onChecking: ->
            Console.messageStart("Checking origin server for app udpates: ")
        , onDownloading: ->
            $("#idConsole").show()
            Console.messageEnd("<strong>Updating</strong>")
            Console.messageStart("files ")
        , onProgress: (fileCount_) ->
            Console.messageRaw(".")
        , onError: ->
            $("#idConsole").show()
            phase2Out.appCacheMonitorState = "error"
            Console.messageEnd(" <strong>OH SNAP!</strong>")
            Console.messageRaw("<h2>attention please</h2>")
            Console.messageRaw("<p>There has been a disturbance in the force.</p>")
            Console.messageRaw("<p>Please refresh this page to try try again.</p>")
            phase2Out.appCacheTerminalState = "error"
        , onObsolete: ->
            $("#idConsole").show()
            phase2Out.appCacheMonitorState = "obsolete"
            Console.messageEnd(" <strong>APP CACHE OBSOLETED</strong>")
            Console.messageRaw("<h2>attention please</h2>")
            Console.messageRaw("<p>We're sorry to inconvience you!</p>")
            Console.messageRaw("<p>Encapsule Project has issued a service advisory for #{appName} v#{appVersion} build ID #{appBuildId} and temporarily suspended service.</p>")
            Console.messageRaw("<p>Please visit <a href=\"#{appBlogUrl}\" title=\"#{appBlogName}\">#{appBlogName}</a> for the news and advisories.</p>")
        , onOffline: ->
            phase2Out.appCacheMonitorState = "offline"
            Console.messageEnd("<strong>OFFLINE</strong>");
            Console.message("Origin server is unreachable. Please try again later.")
            phase3(bootstrapperOptions_)
        , onCached: (fileCount_) ->
            phase2Out.appCacheMonitorState = "cached"
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.message("<strong>The application has been installed!</strong>")
            Console.messageRaw("<h2>app cached</h2>")
            $("#idConsole").fadeOut(2000)
            setTimeout ( ->
                phase3(bootstrapperOptions_) )
                , 2000
        , onNoUpdate: ->
            phase2Out.appCacheMonitorState = "noupdate"
            Console.messageEnd("<strong>No update<strong>")
            Console.message("The most recent build of #{appName} is already cached locally for offline access.");
            Console.message("No updates were necessary.")
            phase3(bootstrapperOptions_)
        , onUpdateReady: (fileCount_) ->
            $("#idConsole").show()
            phase2Out.appCacheMonitorState = "updateready"
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.messageRaw("<h2>app cache updated</h2>")
            $("#idConsole").fadeOut(2000)
            setTimeout ( ->
                try
                    window.applicationCache.swapCache()
                    window.location.reload(true)
                catch exception
                    Console.message("Well that's interesting... While attempting to swap in the newly updated application cache we caught an unexpected exception.")
                    Console.message("I _believe_ this is exceptionally rare and occurs only when the app has previously been cached from a FQ path (e.g. http://schema.encapsule.org/schema.html) and is then accessed via a non-qualified URL (e.g. http://schema.encapsule.org).")
                    Console.messageRaw("<p>If you encounter this error under different circumstances please let me know.</p>")
                    Console.messageRaw("<p><strong>Note: you can typically recover from a DOM exception in this case by simply refreshing the page.</strong></p>")
                    Console.messageError(exception)
                ) , 2000
        }
    appCacheMonitor = new Encapsule.core.boot.AppCacheMonitor(appCacheCallbacks)

phase3 = (bootstrapperOptions_) ->

    Console.messageRaw("<h3>BOOTSTRAP PHASE 3</h3>")      

    phase3Out = bootstrapperOptions_.phase3 = {}
    phase3Out.originServerOnline = false
    blipper = phase3Out.blipper = Encapsule.schema.widget.audioTheme.create($("body"))

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
            else
                blipper.blip "xindi-off"
            ), checkOnlineOptions
        )

    Console.message("Checking online status.")
    checkOnlineFunction()
    onlineCheckPeriodMs = 10 * 60 * 1000
    Console.message("Online status will be checked periodically every #{onlineCheckPeriodMs / 60000} minutes.")
    setInterval ( -> checkOnlineFunction() ), onlineCheckPeriodMs

    # We're done with bootrapping?
    bootstrapperOptions_.onBootstrapComplete "Everything is going extremely well."    

class namespaceCore.bootstrapper
    
    @run: (bootstrapperOptions_) ->
        if not bootstrapperOptions_? or not bootstrapperOptions_
            throw "You must specify a callback function to be called on success."
        @phase1(bootstrapperOptions_, @phase2)

    @phase1: phase1
    @phase2: phase2
    @phase3: phase3



