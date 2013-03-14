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
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
namespaceEncapsule_code_lib_view = Encapsule.code.lib.view? and Encapsule.code.lib.view or @Encapsule.code.lib.view = {}


# http://fgnass.github.com/spin.js/#?

optionsDefault = {
    lines: 11,
    length: 0,
    width: 5,
    radius: 7,
    corners: 0,
    rotate: 0,
    trail: 33,
    speed: 1.0,
    color: "#006600",
    shadow: off,
    hwaccel: on
    }

class namespaceEncapsule_code_lib_view.spinner
    embeddedSpinnerObject: undefined
    enabled: false

    optionsDefault: optionsDefault
   
    constructor: ->
        Console.message("Constructed a spinner wrapper object.")

    draw: (options_) ->
        if not @enabled
            options = options_? and options_ or @optionsDefault
            spinnerJN = $("#idSpinner")
            spinnerJN.html($("""<div id="idSpinnerHostContainer"></div>"""))
            spinnerHostJN = $("#idSpinnerHostContainer")
            spinnerHostDN = document.getElementById("idSpinnerHostContainer")
            spinnerJN.hide().fadeIn(1000)
            @embeddedSpinnerObject = new Spinner(options).spin(spinnerHostDN)
            spinnerJN.append($("""<img id="idSpinnerCore" src="img/core-yellow-128x128.png"
            style="margin-left: -66px; margin-top: -65px; 
            opacity: 0.7; background-color: #0099CC;
            -webkit-border-radius: 0.75em; -moz-border-radius: 0.75em; border-radius: 0.75em;
            border: 2px solid #CCCCFF;
            ">
            """))
            @enabled = true

    cancel: ->
        if @enabled
            targetJN = $("#idSpinner")
            targetJN.fadeOut(2000)
            embeddedSpinnerObject = @embeddedSpinnerObject
            $("#idSpinnerCore").attr { src: "img/core-green-128x128.png" }   
            @enabled = false
            setTimeout( ( ->
                embeddedSpinnerObject.stop()
                $("#idSpinner").html("")
                )
                , 2000)

