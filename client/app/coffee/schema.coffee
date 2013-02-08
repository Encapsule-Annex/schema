#
# schema.coffee
#

class schemaApplication
    @appBootContext = undefined

    constructor: (appBootContext_) ->
        @appBootContext = appBootContext_
        @

    run: ->
        bodyElement = $("body")
        bodyElement.html ""
        Encapsule.view.widget.logo.draw(bodyElement, Encapsule.view.widget.logo.optionsDefault)

        # Setup closure
        blipper = @appBootContext.blipper

        # Acknowledge page loaded
        blipper.blip("beep")

        # Then announce
        setTimeout((-> blipper.blip "update-complete"), 1000)

        # Set background
        blipper.blip("regen")
        setTimeout((-> blipper.blip "regen-abort"), 6800)
     

        # Set the heart beat beacon
        setInterval((-> blipper.blip "heartbeat"), 60000)

        Encapsule.audio.widget.util.blipAtRandom blipper, "beep4", 1000, 7000





$ ->
    try
        # APP BOOT PHASE 1 : Supported browser
        #
        # Draw the boot UI
        # Initialize the debug console for this app instance
        # Confirm the visitor's browser identity and reject unsupported browsers.
        # If unsupported browser display browser help UI
        # If supported browser proceed silently and immediately to phase 2
    
        Console.init()
        Console.message("Hello from the app bootrapper!")
        console.log "#{appName} v#{appVersion} #{appReleaseName} :: #{appPackageId}"
        console.log "#{appName}: #{appBuildTime} by #{appBuilder}"
    
        userAgent = navigator.userAgent
        Console.message("Your browser purports to be a \"#{userAgent}\"")
        browser = $.browser
    

        # APP BOOT PHASE 2 : Application cache monitor
        #
        # Instantiate application cache monitor to hook application cache events.
        # 
        # We expect one of the following sequences of application cache events to occur:
        #

        appCacheCallbacks = {
            onChecking: ->
                Console.messageStart("Checking origin server for app udpates: ")
            , onDownloading: ->
                Console.messageEnd("<strong>UPDATING</strong>")
                Console.messageStart("files ")
            , onProgress: ->
                Console.messageRaw(".")
            , onError: ->
                Console.messageEnd(" <strong>OH SNAP!</strong>")
                Console.message("The download was interrupted. Please try again later.")
            , onOffline: ->
                Console.messageEnd("<strong>OFFLINE</strong>");
                Console.message("Origin server is unreachable. Please try again later.")
            , onCached: (fileCount_) ->
                Console.messageEnd(" complete.")
                Console.message("<strong>The application has been installed!</strong>")
                Console.message("#{fileCount_} files installed.")
            , onNoUpdate: ->
                Console.messageEnd("<strong>NO UPDATE<strong>")
                Console.message("You already have the latest build installed.")
            , onUpdateReady: (fileCount_) ->
                Console.messageEnd(" complete.")
                Console.message("<strong>UPDATE COMPLETE.</strong>")
                Console.message("#{fileCount_} files installed for offline use.")
                Console.messageRaw("<h2>applying update</h2>")
                setTimeout ( -> window.location.reload(true) ), 2000
            }

        appCacheMonitor = new Encapsule.core.boot.AppCacheMonitor(appCacheCallbacks)

        return;

        appCacheMonitor();

        checkOnlineOptions = {
            timeout: 6000,
            pingRelative: true,
            pingFilePrefix: "json/client-ping",
            pingArgs: "?appId=#{appId}&appVerId=#{appReleaseId}&appBuildId=#{appBuildId}&pingTime=#{Encapsule.util.getEpochTime()}"
            }
    
        checkOnline( ( (online_) ->
            if online? and online_
                console.log "#{appName}: You are reported as being ONLINE."
            else
                console.log "#{appName}: You are reported as being OFFLINE."
            ), checkOnlineOptions )
    
        blipper = Encapsule.schema.widget.audioTheme.create($("body"))
        blipper.blip "heartbeat"
     
        appBootContext = { blipper: blipper }
    
        # Create the application object and call its run method. Note the timer simulates
        # several steps taht need to occur to ascertain on/offline status

        ###
        schemaApp = new schemaApplication(appBootContext)
        setTimeout ( ->

            schemaApp.run() ),
            6000
        ####

        Console.message("document.onLoad handler exit.")
        @

    catch exception
        Console.messageError(exception)




