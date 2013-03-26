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
# schema-view-model-layout.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


###
Dig this >:)-~
###
Encapsule.code.app.viewLayout = {

    # id: some unique string that will be assigned to the ID attibute of the window manager's main container.
    # name: whatever you want
    #
    id: "idSchemaWindowManager"
    name: "#{appName} v#{appVersion} Window Manager"
    fadeInTimeMs: 1500 # (defaults to 1500ms if undefined)

    #
    # BODY PAGE ATTRIBUTES
    #
    # bodyPageBackgroundColor: It is assumed the only visible elements drawn on the body page are created and managed by window manager.
    # The color of the page background may optionally be set via bodyPageBackgroundColor and will be visible
    # if glassMargin > 0 or glassOpacity < 1
    #
    pageBackgroundColor: "#00AA66" # (defaults to "white" if undefined)

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
    glassBackgroundImage: "Aspen_trees_2.jpg" # (default is undefined)
    #glassBackgroundImage: "fire-on-the-mountain.jpg"

    #
    # WINDOW MANAGER BASE PLANE ATTRIBUTES
    #
    # Window manager base plane is a glass-centerred rectangular region that "floats" over the glass and behind
    # the plane objects specified in the layout. Typically, the base plane is set to either black or white background
    # color with a low opacity to provide subtle transition effects or signalling.
    #
    windowManagerBackgroundColor: "white" # defaults to "white" if undefined
    windowManagerMargin: 16 # glass edge to window manager edge (defaults to 10 if undefined)
    windowManagerPadding: 16 # window manager edge to plane edge (defaults to 10 if undefined)
    windowManagerOpacity: 0.3 # (defaults to 1 if undefined)

    #
    # Managed window attributes
    #
    globalWindowAttributes: {
        hostWindowBackgroundColor: "black"
        hostWindowOpacity: 0.3
        hostWindowPadding: 5
        chromeWindowBackgroundColor: "#6699CC"
        chromeWindowOpacity: 0.8
        chromeWindowPadding: 5
        windowBorderWidth: 1
        windowBorderColor: "black"
        }

    planes: [
        {
            id: "idSchemaPlaneDefault"
            name: "#{appName} v#{appVersion} Default View Plane"
            splitterStack: [
                {
                    id: "idFrameStackSplitter"                                                                
                    name: "Frame Stack Split"                                        
                    type: "vertical"                                                 
                    Q1WindowDescriptor: undefined                                    
                    Q2WindowDescriptor: {                                            
                        id: "idFrameStack"                                           
                        name: "Frame Stack Window"
                        initialMode: "full"
                        initialEnable: true
                        opacity: 0.8
                        backgroundColor: "#FFFF00"
                        modes: { full: { reserve: 300 }, min: { reserve: 64 } }
                        }
                    },
                {                                                                    
                    id: "idToolbarSplitter"
                    name: "Toolbar Split"                                            
                    type: "horizontal"                                               
                    Q1WindowDescriptor: {                                            
                        id: "idToolbar"                                              
                        name: "Toolbar Window"                                       
                        initialMode: "min"
                        initialEnable: true
                        opacity: 0.8
                        backgroundColor: "#CCCCCC"
                        modes: { full: { reserve: 128 }, min: { reserve: 64 } }      
                        }                                                            
                    Q2WindowDescriptor: undefined
                    },

                {                                                                    
                    id: "idSelect1Splitter"
                    name: "Select 1 Split"                                           
                    type: "vertical"                                                 
                    Q1WindowDescriptor: {                                            
                        id: "idSelect1"                                              
                        name: "Select 1 Window"                                      
                        initialMode: "min"
                        initialEnable: true
                        opacity: 0.8
                        backgroundColor: "#99CCFF"
                        modes: { full: { reserve: 300 }, min: { reserve: 64 } }      
                        }                                                            
                    Q2WindowDescriptor: undefined                                    
                    },
                {                                                                    
                    id: "idSelect2Splitter"
                    name: "Select 2 Split"                                           
                    type: "vertical"                                                 
                    Q1WindowDescriptor: {                                            
                        id: "idSelect2"                                              
                        name: "Select 1 Window"                                      
                        initialMode: "min"
                        initialEnable: true
                        opacity: 0.8
                        backgroundColor: "#CCCCFF"
                        modes: { full: { reserve: 300 }, min: { reserve: 64 } }      
                        }                                                            
                    Q2WindowDescriptor: undefined                                    
                    },
                {                                                                    
                    id: "idSVGEditSplitter"
                    name: "SVG/Edit Split"                                           
                    type: "horizontal"                                               
                    Q1WindowDescriptor: {                                            
                        id: "idSVGPlane"                                             
                        name: "SVG Plane"                                            
                        initialMode: "full"
                        initialEnable: true
                        opacity: 0.8
                        backgroundColor: "white"
                        modes: { full: { reserve: 0 }, min: { reserve: 0 } }         
                        }                                                            
                    Q2WindowDescriptor: {                                            
                        id: "idEdit1"                                                
                        name: "Edit 1 Window"                                        
                        initialMode: "min"
                        initialEnable: true
                        opacity: 0.8
                        backgroundColor: "#00CC00"
                        modes: { full: { reserve: 0 }, min: { reserve: 64 } }        
                        }                                                            
                    }
                ] # / END: splitter stack
            },
            # / END: plan
        {
            id: "idSchemaSettingsPlane"
            name: "#{appName} Settings Plane"
            splitterStack: [
                {
                    id: "idSetttingsPLaneSplitter0"
                    name: "what ever some descriptive text"
                    type: "horizontal"
                    Q1WindowDescriptor: {
                        id: "idSettings1"
                        name: "Settings 1 Window"
                        initialMode: "full"
                        initialEnable: false
                        modes: { full: { reserve: 0 }, min: { reserve: 0 } }
                        }
                    Q2WindowDescriptor: {
                        id: "idSettings2"
                        name: "Settings 2 Window"
                        initialMode: "full"
                        initialEnable: false
                        modes: { full: { reserve: 0 }, min: { reserve: 0 } }
                        }
                    }
                ]
                # / END: splitter stack
            }
            # / END: plane
        ]
        # END: / plane array
    }
    # / END: Encapsule.code.app.viewLayout
