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
# schema-window-manager-layout-root-plane-proto.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.winmgr = Encapsule.code.app.winmgr? and Encapsule.code.app.winmgr or @Encapsule.code.app.winmgr = {}
Encapsule.code.app.winmgr.layout = Encapsule.code.app.winmgr.layout? and Encapsule.code.app.winmgr.layout or @Encapsule.code.app.winmgr.layout = {}
Encapsule.code.app.winmgr.layout.root = Encapsule.code.app.winmgr.layout.root? and Encapsule.code.app.winmgr.layout.root or @Encapsule.code.app.winmgr.layout.root = {}

CommonSettings = Encapsule.code.app.winmgr.layout.CommonSettings

Encapsule.code.app.winmgr.layout.root.PlanePrototype = {
    id: "idPlaneProto"
    name: "Prototype"
    initialEnable: false
    splitterStack: [
        {
            id: "idProtoAddressSplitter"
            name: "Proto Address Splitter"
            type: "horizontal"
            Q1WindowDescriptor: {
                id: "idProtoAddressWindow"
                name: "Proto Address"
                initialMode: "full"
                initialEnable: true
                overflow: "hidden"
                opacity: CommonSettings.windowOpacityDefault
                modes: { full: { reserve: 14 }, min: { reserve: 14 } }      
                backgroundColor: "#0099FF"
            }
            Q2WindowDescriptor: undefined
        }

        {
            id: "idProtoEditAreaOuterSplitter"
            name: "Proto Edit Outer Splitter"
            type: "vertical"

            Q1WindowDescriptor: {
                id: "idProtoEditOuterOptions"
                name: "Options"
                initialMode: "full"
                initialEnable: true
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: "#0099FF"
                modes: { full: { reserve: 256 }, min: { reserve: 128 } }
            }
            Q2WindowDescriptor: {
                id: "idSettings1"
                name: "Settings 1 Window"
                initialMode: "full"
                initialEnable: true
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: "#99CC99"
                modes: { full: { reserve: 0 }, min: { reserve: 0 } }
            }
        }
    ]
} # PlanePrototype

