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

backchannel = Encapsule.runtime.backchannel? and Encapsule.runtime.backchannel or throw "Missing expected Encapsule.runtime.backchannel object."

Encapsule.code.app.bootDelay = 2000
Encapsule.code.app.bootWatchdogTimeout = 10000

Encapsule.code.app.bootChromes = {
    phase0 : { title: "#{appName} HELLO!", backgroundColor: undefined, spinnerText: "HELLO!" }
    phase1 : { title: "#{appName} BOOT", backgroundColor: undefined, spinnerText: "BOOT"  }
    phase2 : { title: "#{appName} INITIALIZING", backgroundColor: undefined, spinnerText: "INITIALIZING"  }
    phase2checking : { title: "#{appName} CHECKING", backgroundColor: undefined, spinnerText: "CHECKING" }
    phase2downloading: { title: "#{appName} UPDATING", backgroundColor: "#004477", spinnerText: "UPDATING"  }
    phase2progress: { title: "#{appName} UPDATE ", backgroundColor: "#004477", spinnerText: "UPDATE "  }
    phase2error: { title: "#{appName} ERROR", backgroundColor: "#FFFF00", spinnerText: "ERROR"  }
    phase2obsolete: { title: "#{appName} LOCKED", backgroundColor: "#FFCC00", spinnerText: "LOCKED"  }
    phase2offline: { title: "#{appName} CACHED", backgroundColor: "#005588", spinnerText: "APP CACHED"  }
    phase2cached: { title: "#{appName} INSTALLED", backgroundColor: "#005588", spinnerText: "APP INSTALLED"  }
    phase2noupdate: { title: "#{appName} CACHED", backgroundColor: "#005588", spinnerText: "APP CACHED"  }
    phase2updateready: { title: "#{appName} UPDATED", backgroundColor: "#005588", spinnerText: "APP UPDATED"  }
    phase3: { title: "#{appName} BOOTED", backgroundColor: undefined, spinnerText: "BOOTED"  }
    schemaStart: { title: "#{appName} STARTING", backgroundColor: undefined, spinnerText: "STARTING" }
    schemaModelView: { title: "#{appName} MV", backgroundColor: undefined, spinnerText: "BUILDING MODEL VIEW" }
    schemaViewModel: { title: "#{appName} VM", backgroundColor: undefined, spinnerText: "BUILDING VIEW MODEL" }
    schemaBind: {title: "#{appName} MVVM ", backgroundColor: undefined, spinnerText: "BINDING MODEL" }
    schemaRender : {title: "#{appName} RENDER", backgroundColor: undefined, spinnerText: "RENDERING MODEL" }
    schemaWelcome : {title: "#{appName} v#{appVersion} (#{appReleasePhase})", backgroundColor: undefined, spinnerText: "READY" }

    #phase2watchdog: { title: "#{appName} ?8|", spinnerText: "hello"  }
    #phase2watchdogNoop: { title: "#{appName} v#{appVersion}", spinnerText: "hello"  }
    #phase2watchdogAction: { title: "#{appName} ?>8!", backgroundColor: "#FFCC00", spinnerText: ""  }
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
    
    spinnerText = bootChrome.spinnerText? and bootChrome.spinnerText or undefined
    if spinnerText and progress_? and progress_ then spinnerText += progress_

    if bootChrome.backgroundColor? and bootChrome.backgroundColor
        $("body").css( { backgroundColor: bootChrome.backgroundColor } )

    if spinnerText? and spinnerText
        Encapsule.runtime.boot.phase0.spinner.updateCaptionText(spinnerText)
            
        


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
        <div id="idSpinner" class="classCentered"></div>
        """))

    phase0Out = bootstrapperOptions_.phase0 = {}
    phase0Out.spinner = new Encapsule.code.lib.view.spinner()
    phase0Out.spinner.draw()

    Encapsule.code.app.setBootChrome("phase0")
    backchannel.log("#{appName} v#{appVersion} starting boot phase 0")

    backchannel.log("""
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
    backchannel.log "#{appPackagePublisher} #{appName} v#{appVersion} #{appReleaseName} :: #{appPackageId}"
    backchannel.log "#{appName}: #{appBuildTime} by #{appBuilder} :: Thanks for using #{appName}. #{appPackagePublisherUrl}"

    blipper = phase0Out.blipper = Encapsule.code.lib.audio.theme.create($("body"))
    blipper.blip "system-starting"


    phase0Out.router = new Encapsule.code.lib.InPageURIRouter()
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
    backchannel.log("#{appName} v#{appVersion} starting boot phase 1")

    backchannel.log("<h3>BOOTSTRAP PHASE 1 : browser check</h3>")

    backchannel.log("Your browser purports to be a \"<strong>#{userAgent}</strong>\"")
    backchannel.log("isChrome=#{isChrome} isWebKit=#{isWebKit} browserVersion=#{browserVersion}")
    if isChrome
        backchannel.log("Your chrome shines brightly.")
    if isWebKit
        backchannel.log("WebKit browsers please us.")
    else
        backchannel.log("We note you're not running Chrome or another WebKit-based browser.")
        backchannel.log("This might work out for you (e.g. Firefox). Most IE users are SOL.")

    # Here's where we could bail and abort the bootstrap. For now we're just
    # pass through.

    bootstrapperOptions = bootstrapperOptions_
    setTimeout( ( -> phase2(bootstrapperOptions_) ), 150)

phase2 = (bootstrapperOptions_) ->
    backchannel.log("<h3>BOOTSTRAP PHASE 2 : offline application cache</h3>")
    blipper = bootstrapperOptions_.phase0.blipper

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
    backchannel.log("#{appName} v#{appVersion} starting boot phase 2 (application cache)")

    # Note to self: This entire subsystem will be completely redesigned using Schema v1.0.

    backchannel.log("This Javacsript is executing in a #{appName} v#{appVersion} app host.")
    backchannel.log("Checking #{appPackagePublisher} origin server for #{appName} updates...")

    appCacheCallbacks = {
        onChecking: ->
            Encapsule.code.app.setBootChrome("phase2checking")
            backchannel.log("#{appName} v#{appVersion} starting boot phase 2: app cache CHECKING")
            phase2Out.appCacheMonitorState = "checking"

        , onDownloading: ->
            Encapsule.code.app.setBootChrome("phase2downloading")
            backchannel.log("#{appName} v#{appVersion} starting boot phase 2: app cache DOWNLOADING")
            backchannel.log("<strong>Updating</strong>")
            backchannel.log("files ")
            phase2Out.appCacheMonitorState = "downloading"
        , onProgress: (fileCount_) ->
            completionPercent = Math.min( Math.floor( (fileCount_ / appBuildCacheFileCount) * 100), 100)
            Encapsule.code.app.setBootChrome("phase2progress", "#{completionPercent}%")
            backchannel.log(".")
            phase2Out.appCacheMonitorState = "progress"

        , onError: ->
            Encapsule.code.app.setBootChrome("phase2error")
            backchannel.log("#{appName} v#{appVersion} starting boot phase 2: app cache ERROR")
            phase2Out.appCacheMonitorState = "error"
            phase2Out.appCacheTerminalState = "error"
            backchannel.log(" <strong>OH SNAP!</strong>")
            backchannel.log("<h2>attention please</h2>")
            backchannel.log("<p>There has been a disturbance in the force.</p>")
            backchannel.log("<p>Please refresh this page to try try again.</p>")
            backchannel.error "An error has occurred caching application files from the #{appPackagePublisher}'s servers."
            throw "Manually refresh your browser to resolve. See log messages above for additional information."
        , onObsolete: ->
            Encapsule.code.app.setBootChrome("phase2obsolete")
            backchannel.log("#{appName} v#{appVersion} starting boot phase 2: app cache OBSOLETE")
            phase2Out.appCacheMonitorState = "locked (obsolete)"
            phase2Out.appCacheTerminalState = "locked (obsolete)"
            backchannel.log(" <strong>APP CACHE OBSOLETED</strong>")
            backchannel.log("<h2>OH SNAP!</h2>")
            backchannel.log("<p>We're sorry to inconvenience you!</p>")
            backchannel.log("<p>Encapsule Project has issued a service advisory for #{appName} v#{appVersion} build ID #{appBuildId} and temporarily suspended service.</p>")
            backchannel.log("<p>Please visit <a href=\"#{appBlogUrl}\" title=\"#{appBlogName}\">#{appBlogName}</a> for the news and advisories.</p>")
            backchannel.error "#{appName} has been locked by Encpausle Project."
        , onOffline: ->
            Encapsule.code.app.setBootChrome("phase2offline")
            backchannel.log("#{appName} v#{appVersion} starting boot phase 2: app cache OFFLINE")
            phase2Out.appCacheMonitorState = "offline"
            phase2Out.appCacheTerminalState = "locked (obsolete)"
            backchannel.log("<strong>OFFLINE</strong>");
            backchannel.log("Origin server is unreachable. Please try again later.")
            backchannel.log("<h2>Launching #{appName} v#{appVersion} from application cache in offline mode.</h2>")
            setTimeout( ( -> phase3(bootstrapperOptions_) ), Encapsule.code.app.bootDelay)
        , onCached: (fileCount_) ->
            Encapsule.code.app.setBootChrome("phase2cached")
            backchannel.log("#{appName} v#{appVersion} starting boot phase 2: app cache CACHED")
            phase2Out.appCacheMonitorState = "cached"
            phase2Out.appCacheTerminalState = "cached"
            blipper.blip "update-complete"
            backchannel.log(" <strong>complete</strong> (#{fileCount_} files updated)")
            backchannel.log("<h2>#{appName} v#{appVersion} is now fully cached for on/offline use. Welcome :)</h2>")
            setTimeout ( ->
                phase3(bootstrapperOptions_) )
                , Encapsule.code.app.bootDelay
        , onNoUpdate: ->
            Encapsule.code.app.setBootChrome("phase2noupdate")
            backchannel.log("#{appName} v#{appVersion} starting boot phase 2: app cache NOUPDATE")
            phase2Out.appCacheMonitorState = "noupdate"
            phase2Out.appCacheTerminalState = "noupdate"
            backchannel.log("<strong>No update<strong>")
            backchannel.log("<h2>Launching #{appName} v#{appVersion} from application cache in online mode.</h2>")
            setTimeout( ( -> phase3(bootstrapperOptions_) ), Encapsule.code.app.bootDelay)
        , onUpdateReady: (fileCount_) ->
            Encapsule.code.app.setBootChrome("phase2updateready")
            backchannel.log("#{appName} v#{appVersion} starting boot phase 2: app cache UPDATEREADY")
            phase2Out.appCacheMonitorState = "updateready"
            phase2Out.appCacheTerminalState = "updateready"
            blipper.blip "update-complete"
            backchannel.log(" <strong>complete</strong> (#{fileCount_} files updated)")
            backchannel.log("<h2> The #{appName} application has been updated :) Booting #{appName} vNext...</h2>")
            backchannel.log("What could go wrong?")
            setTimeout ( ->
                try
                    window.applicationCache.swapCache()
                    window.location.reload(true) # --> in theory, execution of the current version stops here.
                catch exception
                    Encapsule.code.app.setBootChrome("phase2watchdog")
                    backchannel.log("Well that's interesting... While attempting to swap in the newly updated application cache we caught an unexpected exception.")
                    backchannel.log("I _believe_ this is exceptionally rare and occurs only when the app has previously been cached from a FQ path (e.g. http://schema.encapsule.org/schema.html) and is then accessed via a non-qualified URL (e.g. http://schema.encapsule.org).")
                    backchannel.log("<p>If you encounter this error under different circumstances please let me know.</p>")
                    backchannel.log("<p><strong>Note: you can typically recover from a DOM exception in this case by simply refreshing the page.</strong></p>")
                    backchannel.error(exception)
                ) , Encapsule.code.app.bootDelay
        }
    try
        phase2Out.appCacheMonitor = new Encapsule.code.lib.ApplicationCacheMonitor(appCacheCallbacks)

    catch exception
        backchannel.error(exception)


phase3 = (bootstrapperOptions_) ->

    backchannel.log("<h3>BOOTSTRAP PHASE 3 : online status monitoring</h3>")

    bootstrapperOptions_.phase2.appCacheMonitor.stop()   

    phase3Out = bootstrapperOptions_.phase3 = {}
    phase3Out.originServerOnline = false

    blipper = bootstrapperOptions_.phase0.blipper

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
                blipper.blip "12"
                backchannel.log """
                    <p>
                        #{appName} online check #{Date()}: <strong>ONLINE</strong><br>
                        ... #{appPackagePublisherUrl}/#{checkOnlineOptions.pingFilePrefix} was retrieved.
                    </p>"""
            else
                blipper.blip "11"
                backchannel.log """
                    <p>
                        #{appName} online check #{Date()}: <strong>ONLINE</strong><br>
                        ... #{appPackagePublisherUrl}/#{checkOnlineOptions.pingFilePrefix} could not be retrieved.
                    </p>"""

            ), checkOnlineOptions
        )

    backchannel.log("Checking online status.")
    checkOnlineFunction()
    onlineCheckPeriodMs = 10 * 60 * 1000
    backchannel.log("Online status will be checked periodically every #{onlineCheckPeriodMs / 60000} minutes.")
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



