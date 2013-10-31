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

backchannel = Encapsule.runtime.backchannel? and Encapsule.runtime.backchannel or throw "Missing expected Encapsule.runtime.backchannel object."

# http://fgnass.github.com/spin.js/#?

optionsDefault = {
    lines: 12,
    length: 2,
    width: 4,
    radius: 4,
    corners: 0.2,
    rotate: 0,
    trail: 50,
    speed: 0.5,
    color: "#006699"
    shadow: off,
    hwaccel: on
    }

class namespaceEncapsule_code_lib_view.spinner
    embeddedSpinnerObject: undefined
    enabled: false

    optionsDefault: optionsDefault
   
    constructor: ->
        #backchannel.log("Constructed a spinner wrapper object.")
        @captionUpdateTimer = undefined

    draw: (options_) =>
        if not @enabled
            options = options_? and options_ or @optionsDefault
            spinnerJN = $("#idSpinner")
            spinnerJN.html($("""<div id="idSpinnerHostContainer"></div><div id="idSpinnerTitle">#{appPackagePublisher} #{appName} v#{appVersion}</div><div id="idSpinnerCaption"></div>"""))
            spinnerHostJN = $("#idSpinnerHostContainer")
            spinnerHostDN = document.getElementById("idSpinnerHostContainer")
            spinnerJN.hide().fadeIn(1000)
            @embeddedSpinnerObject = new Spinner(options).spin(spinnerHostDN)
            spinnerJN.append($("""<img id="idSpinnerCore" src="img/core-yellow-128x128.png">
            """))
            spinnerTitleEl = $("#idSpinnerTitle")
            titleOffsetRect = Encapsule.code.lib.geometry.offsetRectangle.createFromDimensions(600, 64)
            spinnerTitleEl.css(
                {
                    marginLeft: titleOffsetRect.offset.left + "px"
                    marginTop: titleOffsetRect.offset.top + 110 + "px"
                    width: titleOffsetRect.rectangle.extent.width + "px"
                    height: titleOffsetRect.rectangle.extent.height + "px"
                    }
                )
            spinnerCaptionEl = $("#idSpinnerCaption")
            captionOffsetRect = Encapsule.code.lib.geometry.offsetRectangle.createFromDimensions(600, 32)
            spinnerCaptionEl.css(
                {
                    marginLeft: captionOffsetRect.offset.left + "px"
                    marginTop: captionOffsetRect.offset.top + 123 + "px"
                    width: captionOffsetRect.rectangle.extent.width + "px"
                    height: captionOffsetRect.rectangle.extent.height + "px"
                    }
                )

            @enabled = true

            @updateCaptionText = (captionText_) ->
                if captionText_? and captionText_
                    spinnerCaptionEl = $("#idSpinnerCaption")
                    spinnerCaptionEl.html captionText_

    cancel: =>
        if @enabled
            targetJN = $("#idSpinner")
            targetJN.fadeOut(3000)
            clearInterval( @captionUpdateTimer )
            embeddedSpinnerObject = @embeddedSpinnerObject
            $("#idSpinnerCore").attr { src: "img/core-green-128x128.png" }   
            @enabled = false
            setTimeout( ( ->
                embeddedSpinnerObject.stop()
                $("#idSpinner").html("")
                )
                , 3000)


