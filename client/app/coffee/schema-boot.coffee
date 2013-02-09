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

    Console.message("Blah blah browser identity spew...")
    Console.message("#{userAgent}")
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
    phase2(bootstrapperOptions_)

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
            Console.messageRaw("<p>Please refresh your browser to try again.</p>")
            Console.messageRaw("<p>If the problem persists, I've been abducted. Please notify the authorities.<p>")
            Console.messageRaw("<p>More seriously, if you absolutely can't get by PHASE 2 bootstrap, please send me an e-mail.</p>")
            appCacheTerminalState = "error"
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
            Console.message("You have the latest build schema #{appReleaseName} build installed.")
            appCacheTerminalState = "noupdate"
            phase3(bootstrapperOptions_)
        , onUpdateReady: (fileCount_) ->
            Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
            Console.messageRaw("<h2>applying update</h2>")
            # setting the appCacheTerminalState is pointless in this case.
            setTimeout ( -> window.location.reload(true) ), 2000
        }
    appCacheMonitor = new Encapsule.core.boot.AppCacheMonitor(appCacheCallbacks)

phase3 = (boostrapperOptions_) ->
    Console.messageRaw("<h3>BOOTSTRAP PHASE 3</h3>")      

class namespaceCore.bootstrapper
    
    @run: (bootstrapperOptions_) ->
        if not bootstrapperOptions_? or not bootstrapperOptions_
            throw "You must specify a callback function to be called on success."
        @phase1(bootstrapperOptions_, @phase2)

    @phase1: phase1
    @phase2: phase2
    @phase3: phase3



