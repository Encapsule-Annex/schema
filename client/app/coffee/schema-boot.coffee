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

    document.title = "#{appName}: booting..."

    Console.init()
    Console.show()
    Console.messageRaw("""
        <div id="idPreBootMessage">
            <p><strong>This application uses HTML5 features are not supported by any version of Microsoft's Internet Explorer browser.</strong></p>
            <p>Please ensure that you are using the latest version of one of the following supported browser:</p>
            <h4>Supported Browsers:</h4>
            <ul>
                <li><a href="https://www.google.com/intl/en/chrome/browser/" title="Install Chrome">Google Chrome</a></li>
                <li><a href="http://www.apple.com/safari/" title="Install Safari">Apple Safari</a></li>
                <li><a href="http://www.mozilla.org/en-US/" title="Install Firefox">Mozilla Firefox</a></li>
            </ul>
        </div>
        <h3>BOOTSTRAP PHASE 0</h3>
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

    Console.messageRaw("<h3>BOOTSTRAP PHASE 1</h3>")

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
    setTimeout( ( -> phase2(bootstrapperOptions_) ), 1)

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
    phase2Out.appCacheTerminalState = undefined

    appCacheCallbacks = {
        onChecking: ->
            Console.messageStart("Checking origin server for app udpates: ")
            document.title = "#{appName}: checking for updates ..."
        , onDownloading: ->
            document.title = "#{appName}: downloading updates..."
            Console.messageEnd("<strong>Updating</strong>")
            Console.messageStart("files ")
        , onProgress: (fileCount_) ->
            document.title = "#{appName}: #{Math::round((fileCount_ / appBuildCacheFileCount) * 100)}% ..."
            Console.messageRaw("#")
        , onError: ->
            document.title = "#{appName}: boot error!"
            phase2Out.appCacheMonitorState = "error"
            phase2Out.appCacheTerminalState = "error"
            Console.messageEnd(" <strong>OH SNAP!</strong>")
            Console.messageRaw("<h2>attention please</h2>")
            Console.messageRaw("<p>There has been a disturbance in the force.</p>")
            Console.messageRaw("<p>Please refresh this page to try try again.</p>")
            Console.messageError "An error has occurred caching application files from the #{appPackagePublisher}'s servers."
        , onObsolete: ->
            document.title = "#{appName}: package locked!"
            phase2Out.appCacheMonitorState = "locked (obsolete)"
            phase2Out.appCacheTerminalState = "locked (obsolete)"
            Console.messageEnd(" <strong>APP CACHE OBSOLETED</strong>")
            Console.messageRaw("<h2>OH SNAP!</h2>")
            Console.messageRaw("<p>We're sorry to inconvience you!</p>")
            Console.messageRaw("<p>Encapsule Project has issued a service advisory for #{appName} v#{appVersion} build ID #{appBuildId} and temporarily suspended service.</p>")
            Console.messageRaw("<p>Please visit <a href=\"#{appBlogUrl}\" title=\"#{appBlogName}\">#{appBlogName}</a> for the news and advisories.</p>")
            Console.messageError "#{appName} has been locked by Encpausle Project."
        , onOffline: ->
            document.title = "#{appName}: boot from cache..."
            phase2Out.appCacheMonitorState = "offline"
            phase2Out.appCacheTerminalState = "locked (obsolete)"
            Console.messageEnd("<strong>OFFLINE</strong>");
            Console.message("Origin server is unreachable. Please try again later.")
            Console.messageRaw("<h2>#{appPackagePublisher} origin server unreachable. #{appName} starting...</h2>")
            setTimeout( ( -> phase3(bootstrapperOptions_) ), 2000)
        , onCached: (fileCount_) ->
            phase2Out.appCacheMonitorState = "cached"
            phase2Out.appCacheTerminalState = "cached"
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.message("<strong>The application has been installed!</strong>")
            Console.messageRaw("<h2>#{appPackagePublisher} #{appName} v#{appVersion} #{appReleaseName} installed! Starting...</h2>")
            document.title = "#{appName}: rebooting..."
            setTimeout ( ->
                phase3(bootstrapperOptions_) )
                , 2000
        , onNoUpdate: ->
            document.title = "#{appName}: application cached"
            phase2Out.appCacheMonitorState = "noupdate"
            phase2Out.appCacheTerminalState = "noupdate"
            Console.messageEnd("<strong>No update<strong>")
            Console.message("The most recent build of #{appName} is already cached locally for offline access.");
            Console.message("No updates were necessary.")
            Console.messageRaw("<h2>#{appPackagePublisher} #{appName} is up-to-date. Starting...</h2>")
            setTimeout( ( -> phase3(bootstrapperOptions_) ), 2000)
        , onUpdateReady: (fileCount_) ->
            $("#idConsole").show()
            phase2Out.appCacheMonitorState = "updateready"
            phase2Out.appCacheTerminalState = "updateready"
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.messageRaw("<h2>#{appPackagePublisher} #{appName} has been updated. Restarting...</h2>")
            document.title = "#{appName}: rebooting..."
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
    try
        phase2Out.appCacheMonitor = new Encapsule.code.lib.appcachemonitor(appCacheCallbacks)

        # I don't any way to actually detect if the cache has been updated before the event listeners are registered.
        # There simply isn't enough information available from the applicationCache object to determine what's happened
        # already.
        # Let's say that if none of our monitoring callbacks are invoked within two seconds that AND the reported cache
        # status is IDLE that we missed the show and everything is set to go.
        setTimeout( ( ->
            applicationCacheStatus = window.applicationCache.status
            applicationCacheMonitorState = phase2Out.appCacheMonitorState
            applicationCacheMonitorTerminalState = phase2Out.appCacheTerminalState
            #Console.messageRaw("<br>")
            #Console.message("App cache watchdog: Browser app cache reports status = #{applicationCacheStatus}")
            #Console.message("App cache watchdog: Browser app cache monitor status = #{applicationCacheMonitorState}")
            #Console.message("App cache watchdog: Browser app cache monitor status = #{applicationCacheMonitorTerminalState}")
            if not applicationCacheMonitorTerminalState and  applicationCacheStatus == window.applicationCache.IDLE
                alert("The browser application cache subsystem is not dispatching status events as expected. However, your cached copy of this application appears to be ready to boot. Typically this indicates that you're using Chrome and that your Internet connection is beyond crazy fast (or you're running off a local server). Please click okay to proceed.")
                phase2Out.appCacheRaceConditionBroken = true
                appCacheCallbacks.onNoUpdate()
            else
                phase2Out.appCacheRaceConditionBroken = false
            ), 2000)
    catch exception
        Console.messageError(exception)


phase3 = (bootstrapperOptions_) ->

    Console.messageRaw("<h3>BOOTSTRAP PHASE 3</h3>")

    bootstrapperOptions_.phase2.appCacheMonitor.stop()   

    phase3Out = bootstrapperOptions_.phase3 = {}
    phase3Out.originServerOnline = false
    blipper = phase3Out.blipper = Encapsule.code.lib.audio.theme.create($("body"))

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



