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
# schema-window-manager-layout-root-plane-advanced.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.winmgr = Encapsule.code.app.winmgr? and Encapsule.code.app.winmgr or @Encapsule.code.app.winmgr = {}
Encapsule.code.app.winmgr.layout = Encapsule.code.app.winmgr.layout? and Encapsule.code.app.winmgr.layout or @Encapsule.code.app.winmgr.layout = {}
Encapsule.code.app.winmgr.layout.root = Encapsule.code.app.winmgr.layout.root? and Encapsule.code.app.winmgr.layout.root or @Encapsule.code.app.winmgr.layout.root = {}

CommonSettings = Encapsule.code.app.winmgr.layout.CommonSettings

Encapsule.code.app.winmgr.layout.root.SchemaD3 = {


    id: "idSchemaPlaneD3"
    name: "OMM/D3"
    initialEnable: false
    splitterStack: [
        Encapsule.code.app.winmgr.layout.PlaneSelectSplitterHorizontalBottom
        {
            id: "idSchemaPlaneD3Splitter"
            name: "D3 Plane Splitter"
            type: "horizontal"
            Q1WindowDescriptor: {
                id: "idSchemaD3Main"
                name: "D3 Main"
                initialMode: "full"
                initialEnable: true
                overflow: "auto"
                opacity: 1.0
                backgroundColor: "rgba(100,255,255,0.3)"
                modes: { full: { reserve: 0}, min: { reserve: 0 } }
                MVVM: {
                    modelView: -> Encapsule.runtime.app.SchemaD3Main
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelSvgPlane"
                }

            }
            Q2WindowDescriptor: undefined
        }
    ]
}