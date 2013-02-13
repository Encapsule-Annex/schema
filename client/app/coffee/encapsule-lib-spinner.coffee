###

  http://schema.encapsule.org/schema.html

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapusle-lib-spinnder.coffee
#
# A thin wrapper over spinner.js (http://fgnass.github.com/spin.js/#!)
# that appends a spinner to the JQuery element passed.
#



namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceView = Encapsule.view? and Encapsule.view or @Encapsule.view = {}
namespaceWidget = Encapsule.view.widget? and Encapsule.view.widget or @Encapsule.view.widget = {}

# http://fgnass.github.com/spin.js/#?

optionsDefault = {
    lines: 7,
    length: 0,
    width: 20,
    radius: 20,
    corners: 0.5,
    rotate: 0,
    trail: 100,
    speed: 1.0,
    color: "#99CCFF",
    shadow: off,
    hwaccel: on
    }

class namespaceWidget.spinner
    embeddedSpinnerObject: undefined
    enabled: false

    optionsDefault: optionsDefault
   
    constructor: ->
        Console.message("Constructed a spinner wrapper object.")

    draw: (options_) ->
        if not @enabled
            options = options_? and options_ or @optionsDefault
            targetDN = document.getElementById("idSpinner")
            targetJN = $("#idSpinner")
            targetJN.hide().fadeIn(1000)
            @embeddedSpinnerObject = new Spinner(options).spin(targetDN)
            @enabled = true

    cancel: ->
        if @enabled
            targetJN = $("#idSpinner")
            targetJN.fadeOut(2000)
            embeddedSpinnerObject = @embeddedSpinnerObject     
            @enabled = false
            setTimeout( ( ->
                embeddedSpinnerObject.stop()
                )
                , 2000)


