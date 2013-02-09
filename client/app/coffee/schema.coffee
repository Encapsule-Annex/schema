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
        bootstrapperOptions = {
            onBootstrapComplete: (bootstrapperStatus_) ->
                Console.message("onBootstrapperComplete with status=#{bootstrapperStatus_}")
        }

        Encapsule.core.bootstrapper.run bootstrapperOptions

        return


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
                Console.messageEnd("<strong>Updating</strong>")
                Console.messageStart("files ")
            , onProgress: (fileCount_) ->
                Console.messageRaw(".")
            , onError: ->
                Console.messageEnd(" <strong>OH SNAP!</strong>")
                Console.message("The download was interrupted. Please try again later.")
            , onOffline: ->
                Console.messageEnd("<strong>OFFLINE</strong>");
                Console.message("Origin server is unreachable. Please try again later.")
            , onCached: (fileCount_) ->
                Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
                Console.message("<strong>The application has been installed!</strong>")
            , onNoUpdate: ->
                Console.messageEnd("<strong>No update<strong>")
                Console.message("You have the latest build, v#{appVersion}, installed.")
            , onUpdateReady: (fileCount_) ->
                Console.messageEnd(" <strong>complete</strong> (#{fileCount_} files updated)")
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




