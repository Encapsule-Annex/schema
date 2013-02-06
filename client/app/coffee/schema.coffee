#
# schema.coffee
#

class schemaApplication
    constructor: ->

    run: ->
        bodyElement = $ "body" 

        Encapsule.view.widget.logo.draw(bodyElement, Encapsule.view.widget.logo.optionsDefault)

        blipper = Encapsule.schema.widget.audioTheme.create(bodyElement)

        # Acknowledge
        blipper.blip("beep")

        # Then announce
        setTimeout((-> blipper.blip "update-complete"), 1000)

        # Set the heart beat beacon
        setInterval((-> blipper.blip "heartbeat"), 60000)





$ ->
    schemaApp = new schemaApplication()

    setTimeout ( ->
        # Clear the document body and execute the appliction.
        $("body").html ""
        schemaApp.run() ),
        5000

    @

        

   






