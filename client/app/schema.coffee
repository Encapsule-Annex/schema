#
# schema.coffee
#

class schemaApplication
    constructor: ->



$ ->

    bodyElement = $ "body" 
    bodyElement.css { backgroundColor: "white", margin: "0px", padding: "0px", overflow: "hidden" }
    Encapsule.view.widget.logo.draw bodyElement, Encapsule.view.widget.logo.optionsDefault


    hal1 = Encapsule.schema.widget.hal9000.create bodyElement
    hal2 = Encapsule.schema.widget.hal9000.create bodyElement

    hal1.blip "comp-link-established"

    setInterval (->
        hal1.blip("doorbell")
        ), 10000

    setInterval (->
        hal1.blip("beep-high")
        ), 3333

    setInterval (->
        hal1.blip("beep-acknowledge")
        ), 30000

    setInterval (->
        hal1.blip("beep-high")
        ), 15000

    setInterval (->
        hal1.blip("beep-tripple")
        ), 60000


    ###
    fireAtRandomInterval = (_name) ->
        interval = 15000 + (Math.random() * 60000)
        x = hal2
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
    ###
    @
   






