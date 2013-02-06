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
    blipper = Encapsule.schema.widget.audioTheme.create($("body"))
    blipper.blip "heartbeat"
 
    appBootContext = { blipper: blipper }

    checkOnlineOptions = {
        timeout: 12000,
        pingRelative: true,
        pingArgs: "?appname=#{appName}&buildname=#{appReleaseName}"
        }

    checkOnline( ( (online_) ->
        if online? and online_
            alert "You are reported as being online."
        else
            alert "You are reported as being OFFLINE."
        ), checkOnlineOptions )

    # Create the application object and call its run method. Note the timer simulates
    # several steps taht need to occur to ascertain on/offline status
    schemaApp = new schemaApplication(appBootContext)
    setTimeout ( ->

        schemaApp.run() ),
        10


    @

        

   






