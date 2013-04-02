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
# encapsule-lib-kohelpers-window-manager-control-panel-layout.coffee
#
# Here we specify just a single plane (not an entire layout) that is used
# for the window manager's "control panel".
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}
Encapsule.code.lib.kohelpers.implementation = Encapsule.code.lib.kohelpers.implementation? and Encapsule.code.lib.kohelpers.implementation or @Encapsule.code.lib.kohelpers.implementation = {}


Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
Encapsule.runtime.app.kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []


Encapsule.code.lib.kohelpers.implementation.WindowManagerControlPanelPlane = {
    id: "idWindowManagerControlPanelPlane"
    name: "Window Manager Control Panel Plane"
    windowManagerReservePlane: true
    splitterStack: [
        {
            id: "idWindowManagerControlPanelSplitter"
            name: "Window Manager Control Panel Splitter"
            type: "horizontal"
            Q1WindowDescriptor: {
                id: "idWindowManagerControlPanel"
                name: "#{appName} Window Manager Control Panel"
                initialMode: "full"
                initialEnable: true
                opacity: 0.6
                backgroundColor: "#00CC99"
                modes: { full: { reserve: 16 }, min: { reserve: 4 } }
                }
            Q2WindowDescriptor: undefined
            }
        ]
    }
