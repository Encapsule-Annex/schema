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
         
    Console.init()
    Console.messageRaw("<h3>BOOTSTRAP PHASE 1</h3>")
    Console.log "#{appName} v#{appVersion} #{appReleaseName} :: #{appPackageId}"
    Console.log "#{appName}: #{appBuildTime} by #{appBuilder}"

    phase1Out = bootstrapperOptions_.phase1 = {}

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
    appCacheTerminalState = phase2Out.appCacheMonitorTerminalState = undefined

    appCacheCallbacks = {
        onChecking: ->
            Console.messageStart("Checking origin server for app udpates: ")
        , onDownloading: ->
            Console.messageEnd("<strong>Updating</strong>")
            Console.messageStart("files ")
        , onProgress: (fileCount_) ->
            Console.messageRaw(".")
        , onError: ->
            Console.messageEnd(" <strong>OH SNAP!</strong>")
            Console.messageRaw("<h3>attention please</h3>")
            Console.messageRaw("<p>There has been a disturbance in the force.</p>")
            Console.messageRaw("<p>Please refresh this page to try try again.</p>")
            appCacheTerminalState = "error"
        , onObsolete: ->
            Console.messageEnd(" <strong>APP CACHE OBSOLETED</strong>")
            Console.messageRaw("<h3>attention please</h3>")
            Console.messageRaw("<p>An updated version of #{appName} is required to proceed.</p>")
            Console.messageRaw("<p>Sorry to inconvenience you. The update should be available shortly.</p>")
            Console.messageRaw("<p>Please refresh this page to check for update.</p>")
        , onOffline: ->
            Console.messageEnd("<strong>OFFLINE</strong>");
            Console.message("Origin server is unreachable. Please try again later.")
            appCacheTerminaState = "offline"
            phase3(bootstrapperOptions_)
        , onCached: (fileCount_) ->
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.message("<strong>The application has been installed!</strong>")
            appCacheTerminalState = "cached"
            phase3(bootstrapperOptions_)
        , onNoUpdate: ->
            Console.messageEnd("<strong>No update<strong>")
            Console.message("The most recent build of #{appName} is already cached locally for offline access.");
            Console.message("No updates were necessary.")
            appCacheTerminalState = "noupdate"
            phase3(bootstrapperOptions_)
        , onUpdateReady: (fileCount_) ->
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.messageRaw("<h2>applying update</h2>")
            # setting the appCacheTerminalState is pointless in this case.
            setTimeout ( -> 
                window.applicationCache.swapCache()
                window.location.reload(true) )
                , 2000
        }
    appCacheMonitor = new Encapsule.core.boot.AppCacheMonitor(appCacheCallbacks)

phase3 = (bootstrapperOptions_) ->

    Console.messageRaw("<h3>BOOTSTRAP PHASE 3</h3>")      

    phase3Out = bootstrapperOptions_.phase3 = {}
    originServerOnline = phase3Out.originServerOnline = false
    blipper = phase3Out.blipper = Encapsule.schema.widget.audioTheme.create($("body"))

    checkOnlineOptions = {
        timeout: 5000,
        pingRelative: true,
        pingFilePrefix: "no-cache/json/client-ping",
        #pingArgs: "?appBuildId=#{appBuildId}&pingTime=#{Encapsule.util.getEpochTime()}"
        }

    checkOnlineFunction = ( ->

        checkOnline ((statusIn_) -> 
            originServerOnline = statusIn_
            if statusIn_
                blipper.blip "blip"
            else
                blipper.blip "heartbeat"
            ), checkOnlineOptions
        )

    Console.message("Checking online status.")
    checkOnlineFunction()
    onlineCheckPeriodMs = 10 * 60 * 1000
    Console.message("Online status will be checked periodically every #{onlineCheckPeriodMs / 60000} minutes.")
    setInterval ( -> checkOnlineFunction() ), 10 * 60 * 1000

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



