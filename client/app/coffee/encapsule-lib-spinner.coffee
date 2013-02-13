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
    length: 1,
    width: 18,
    radius: 10,
    corners: 0.5,
    rotate: 0,
    trail: 100,
    speed: 0.7,
    color: "#99CCFF",
    shadow: off,
    hwaccel: on

    }

drawSpinner = (options_) ->
    options = options_? and options_ or @optionsDefault
    target = document.getElementById('idSpinner')
    spinner = new Spinner(options).spin(target)


cancelSpinner = ->
     $("idSpinner").remove()

class namespaceWidget.spinner
    constructor: ->
 
    @optionsDefault: optionsDefault
    @draw: drawSpinner
