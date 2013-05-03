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
# schema-window-manager-layout-plane-select-splitter.coffee
#
# Defines a window manager splitter layout object declaration that
# is shared among various plane declarations. 


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.winmgr = Encapsule.code.app.winmgr? and Encapsule.code.app.winmgr or @Encapsule.code.app.winmgr = {}
Encapsule.code.app.winmgr.layout = Encapsule.code.app.winmgr.layout? and Encapsule.code.app.winmgr.layout or @Encapsule.code.app.winmgr.layout = {}

CommonSettings = Encapsule.code.app.winmgr.layout.CommonSettings

Encapsule.code.app.winmgr.layout.PlaneSelectSplitter = {
    id: "idWindowManagerControlPanelSplitter"
    name: "Window Manager Control Panel Splitter"
    type: "horizontal"
    Q1WindowDescriptor: {
        id: "idWindowManagerControlPanel"
        name: "#{appName} Window Manager Control Panel"
        initialMode: "min"
        initialEnable: true
        opacity: CommonSettings.windowOpacityDefault
        backgroundColor: undefined # "#CCCCCC"
        modes: { full: { reserve: 28 }, min: { reserve: 22 } }
        MVVM: {
            fnModelView: -> Encapsule.runtime.app.windowmanager.WindowManagerControlPanel
            viewModelTemplateId: "idKoTemplate_WindowManagerControlPanel"
        }
    }
    Q2WindowDescriptor: undefined
}

Encapsule.code.app.winmgr.layout.PlaneSelectSplitterHorizontalBottom = Encapsule.code.lib.js.clone(Encapsule.code.app.winmgr.layout.PlaneSelectSplitter)
Encapsule.code.app.winmgr.layout.PlaneSelectSplitterHorizontalBottom.Q1WindowDescriptor = Encapsule.code.app.winmgr.layout.PlaneSelectSplitter.Q2WindowDescriptor
Encapsule.code.app.winmgr.layout.PlaneSelectSplitterHorizontalBottom.Q2WindowDescriptor = Encapsule.code.app.winmgr.layout.PlaneSelectSplitter.Q1WindowDescriptor
