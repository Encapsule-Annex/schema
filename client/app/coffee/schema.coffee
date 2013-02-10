#
# schema.coffee
#


$ ->
    try

        Encapsule.core.bootstrapper.run {
            onBootstrapComplete: (bootstrapperStatus_) ->
                Console.message("onBootstrapperComplete with status=#{bootstrapperStatus_}")
        }
        return @



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




