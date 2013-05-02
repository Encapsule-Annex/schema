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
# schema-view-model-layout-root.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.winmgr = Encapsule.code.app.winmgr? and Encapsule.code.app.winmgr or @Encapsule.code.app.winmgr = {}
Encapsule.code.app.winmgr.layout = Encapsule.code.app.winmgr.layout? and Encapsule.code.app.winmgr.layout or @Encapsule.code.app.winmgr.layout = {}
Encapsule.code.app.winmgr.layout.root = Encapsule.code.app.winmgr.layout.root? and Encapsule.code.app.winmgr.layout.root or @Encapsule.code.app.winmgr.layout.root = {}


CommonSettings = Encapsule.code.app.winmgr.layout.CommonSettings

try
    Encapsule.code.app.winmgr.layout.root.Layout = {

        # id: some unique string that will be assigned to the ID attibute of the window manager's main container.
        # name: whatever you want
        #
        id: "idSchemaWindowManager"
        name: "#{appName} v#{appVersion} Window Manager"
        fadeInTimeMs: undefined # (defaults to 1500ms if undefined)

        #
        # BODY PAGE ATTRIBUTES
        #
        # bodyPageBackgroundColor: It is assumed the only visible elements drawn on the body page are created and managed by window manager.
        # The color of the page background may optionally be set via bodyPageBackgroundColor and will be visible
        # if glassMargin > 0 or glassOpacity < 1
        #
        pageBackgroundColor: "#333333" # (defaults to "white" if undefined)

        #
        # WINDOW MANAGER "GLASS" ATTRIBUTES
        #
        # Window manager "glass" is a page-centerred rectangular region that serves as a background for your application.
        # Note that setting glassBackgroundImage will occlude glassBackgroundColor if specified. You can however
        # acheive splendid blending effects by setting bodyPageBackgroundColor and glassOpacity.
        #        
        glassOpacity: 1 # defaults to 1 if undefined
        glassBackgroundColor: undefined
        glassMargin: 0 # document edge to glass edge (default is 10)
        glassBackgroundImage: "brushed-metal-1920x1080.jpg" # (default is undefined)
        # glassBackgroundImage: "background_linen.jpg" # (default is undefined)

    
        #
        # WINDOW MANAGER BASE PLANE ATTRIBUTES
        #
        # Window manager base plane is a glass-centerred rectangular region that "floats" over the glass and behind
        # the plane objects specified in the layout. Typically, the base plane is set to either black or white background
        # color with a low opacity to provide subtle transition effects or signalling.
        #
        windowManagerBackgroundColor: "black" # defaults to "white" if undefined
        windowManagerMargin: 0  # glass edge to window manager edge (defaults to 10 if undefined)
        windowManagerPadding: 1  # window manager edge to plane edge (defaults to 10 if undefined)
        windowManagerOpacity: 0.5 # (defaults to 1 if undefined)

        #
        # Managed window attributes
        #
        # Note to self: implement a preprocessing step in the window manager
        # to clone attributes into window descriptors missing these attributes
        # (sort of poor man's attribute inheritence to reduce typing/error)
        #
        globalWindowAttributes: {
            hostWindowBackgroundColor: undefined
            hostWindowOpacity: 1
            hostWindowPadding: 1
            chromeWindowBackgroundColor: undefined
            chromeWindowOpacity: 1
            chromeWindowPadding: 1
            windowBorderWidth: 1
            windowBorderColor: "#444444"
            windowPadding: 2
            }

        planes: [
            Encapsule.code.app.winmgr.layout.root.PlaneHome
            # Encapsule.code.app.winmgr.layout.root.PlanePrototype # Keep in source as reference. We may want this layout for something?
            Encapsule.code.app.winmgr.layout.root.PlaneAdvanced # Now "Catalogue"
            Encapsule.code.app.winmgr.layout.root.PlaneCatalogue # Now "Catalogue (pass 1)"
            Encapsule.code.app.winmgr.layout.root.PlaneDebug # Now "About"
            ]
        }
        # / END: Encapsule.code.app.viewLayout
catch exception
    alert("Load-time parse error in window manager layout declaration: #{exception}")