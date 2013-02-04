#
# schema.coffee
#

class schemaApplication
    constructor: ->



$ ->

    bodyElement = $ "body" 
    bodyElement.css { backgroundColor: "white", margin: "0px", padding: "0px", overflow: "hidden" }
    Encapsule.view.widget.logo.draw bodyElement, Encapsule.view.widget.logo.optionsDefault


    blipHost = Encapsule.audio.widget.blipper.createHost bodyElement
    blipper = blipHost.createBlipper "test", "audio/doorbell.wav"

    #blipHost.blip("test")

    setInterval (->
        #blipHost.blip("test")
        ), 3000

    hal = Encapsule.schema.widget.hal9000.create bodyElement





    fireAtRandomInterval = (_name) ->
        interval = 5000 + (Math.random() * 25000)
        x = hal
        setTimeout ( ->  
            x.blip(_name)
            x = x
            fireAtRandomInterval(_name) ), interval


    fireAtRandomInterval "doorbell"
    fireAtRandomInterval "electronics"
    fireAtRandomInterval "beep-acknowledge"
    fireAtRandomInterval "beep-alert1"
    fireAtRandomInterval "beep-blip"
    fireAtRandomInterval "beep-blurble"
    fireAtRandomInterval "beep-high"
    fireAtRandomInterval "beep-tripple"
    fireAtRandomInterval "beep-unexpected"
    fireAtRandomInterval "comp-awaiting-input"
    fireAtRandomInterval "comp-emergency-power"
    fireAtRandomInterval "comp-link-established"
    fireAtRandomInterval "comp-update-complete"

    @
   






