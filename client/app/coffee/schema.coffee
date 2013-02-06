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

        # Acknowledge
        blipper.blip("beep")

        closureContext = @context

        # Then announce
        setTimeout((=> blipper.blip "update-complete"), 1000)

        # Set the heart beat beacon
        setInterval((=> blipper.blip "heartbeat"), 60000)





$ ->
    blipper = Encapsule.schema.widget.audioTheme.create($("body"))
    blipper.blip "heartbeat"
 
    appBootContext = { blipper: blipper }

    # Create the application object and call its run method. Note the timer simulates
    # several steps taht need to occur to ascertain on/offline status
    schemaApp = new schemaApplication(appBootContext)
    setTimeout ( ->

        schemaApp.run() ),
        5000


    @

        

   






