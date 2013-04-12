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

# Some constants used in the layout declaration below

observableWindowDefaultOpacity = 0.75


###
Dig this >:)-~
###

try
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
        pageBackgroundColor: "white" # (defaults to "white" if undefined)

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
    
        #
        # WINDOW MANAGER BASE PLANE ATTRIBUTES
        #
        # Window manager base plane is a glass-centerred rectangular region that "floats" over the glass and behind
        # the plane objects specified in the layout. Typically, the base plane is set to either black or white background
        # color with a low opacity to provide subtle transition effects or signalling.
        #
        windowManagerBackgroundColor: "white" # defaults to "white" if undefined
        windowManagerMargin: 5  # glass edge to window manager edge (defaults to 10 if undefined)
        windowManagerPadding: 15  # window manager edge to plane edge (defaults to 10 if undefined)
        windowManagerOpacity: 0.4 # (defaults to 1 if undefined)

        #
        # Managed window attributes
        #
        # Note to self: implement a preprocessing step in the window manager
        # to clone attributes into window descriptors missing these attributes
        # (sort of poor man's attribute inheritence to reduce typing/error)
        #
        globalWindowAttributes: {
            hostWindowBackgroundColor: "#EEEEEE"
            hostWindowOpacity: 0.6
            hostWindowPadding: 2
            chromeWindowBackgroundColor: "#666666"
            chromeWindowOpacity: 0.4
            chromeWindowPadding: 1
            windowPadding: 3
            windowBorderWidth: 1
            windowBorderColor: "#333333"
            }

        planes: [
            {
                id: "idSchemaPlaneDefault"
                name: "SCDL Catalogue"
                initialEnable: true
                splitterStack: [
                    {
                        id: "idCatlogueJSONSplitter"                                                                
                        name: "Catlogue JSON Split"                                        
                        type: "vertical"                                                 
                        Q1WindowDescriptor: undefined                                    
                        Q2WindowDescriptor: {                                            
                            id: "idCatalogueJSON"                                           
                            name: "SCDL Catalogue JSON"
                            initialMode: "full"
                            initialEnable: true
                            overflow: "auto"
                            opacity: observableWindowDefaultOpacity
                            backgroundColor: "#00CCFF"
                            modes: { full: { reserve: 400 }, min: { reserve: 128 } }
                            MVVM: {
                                fnModelView: -> Encapsule.runtime.app.SchemaScdlCatalogue
                                viewModelTemplateId: "idKoTemplate_ScdlCatalogueJSONSourceView"
                                }
                            }
                        },
                    {                                                                    
                        id: "idTitleBarSplitter"
                        name: "Title Bar Split"                                            
                        type: "horizontal"                                               
                        Q1WindowDescriptor: {                                            
                            id: "idTitleBar"                                              
                            name: "#{appName} Title Bar"                                       
                            initialMode: "min"
                            initialEnable: false
                            overflow: "auto"
                            opacity: observableWindowDefaultOpacity
                            backgroundColor: "#66CC00"
                            modes: { full: { reserve: 32 }, min: { reserve: 32 } }      
                            MVVM: {
                                modelView: -> Encapsule.runtime.app.SchemaTitleBarWindow
                                viewModelTemplateId: "idKoTemplate_SchemaTitleBarWindow"
                                }
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
                            initialMode: "full"
                            initialEnable: true
                            overflow: "auto"
                            opacity: observableWindowDefaultOpacity
                            backgroundColor: "#00CCFF"
                            modes: { full: { reserve: 200 }, min: { reserve: 32 } }
                            MVVM: {
                                modelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                                viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigator"
                                }
                            }                                                            
                        Q2WindowDescriptor: undefined                                    
                        },
                    
                    {                                                                    
                        id: "idSelect1PathSplitter"
                        name: "Select 1 Path Split"                                           
                        type: "horizontal"                                                 
                        Q1WindowDescriptor: {                                            
                            id: "idSelect1Path"                                              
                            name: "Select 1 Path Window"                                      
                            initialMode: "full"
                            initialEnable: true
                            overflow: "auto"
                            opacity: observableWindowDefaultOpacity
                            backgroundColor: "#99CC00"
                            modes: { full: { reserve: 14 }, min: { reserve: 14 } }
                            MVVM: {
                                modelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                                viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigatorPathWindow"
                                }
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
                            initialMode: "full"
                            initialEnable: true
                            opacity: observableWindowDefaultOpacity
                            backgroundColor: "#00DDFF"
                            overflow: "auto"
                            modes: { full: { reserve: 600 }, min: { reserve: 200 } }
                            MVVM: {
                                # fnModelView and modelView are mutually exclusive. You may only specify one. Specifying both is an error.
                                # if fnModelView is specified, window manager will call the specified function to obtain the observable object instance to host
                                # if modelView is specified, window manager assumes it's the name of a class and calls new to create a new objet instance which it then hosts
                                #
                                fnModelView: -> Encapsule.runtime.app.SchemaScdlCatalogue
                                # modelView: Encapsule.code.app.scdl.ObservableCatalogueShimHost
                                viewModelTemplateId: "idKoTemplate_ScdlCatalogueShimHost"
                                }
                            }                                                            
                        Q2WindowDescriptor: undefined                                    
                        },
                    {                                                                    
                        id: "idEditSplitter"
                        name: "Edit Split"                                           
                        type: "horizontal"                                               
                        Q1WindowDescriptor: undefined                                                           
                        Q2WindowDescriptor: {                                            
                            id: "idEdit1"                                                
                            name: "Edit 1 Window"                                        
                            initialMode: "full"
                            initialEnable: true
                            opacity: observableWindowDefaultOpacity
                            backgroundColor: "#99CC66"
                            modes: { full: { reserve: 0 }, min: { reserve: 32 } }        
                            }                                                            
                        }
    
                    ] # / END: splitter stack
                },
                # / END: plane
            {
                id: "idSchemaSettingsPlane"
                name: "Settings"
                initialEnable: false
                splitterStack: [
                    {
                        id: "idSetttingsPlaneSplitter0"
                        name: "what ever some descriptive text"
                        type: "horizontal"
                        Q1WindowDescriptor: {
                            id: "idSettings1"
                            name: "Settings 1 Window"
                            initialMode: "full"
                            initialEnable: true
                            opacity: observableWindowDefaultOpacity
                            backgroundColor: "#CCCCCC"
                            modes: { full: { reserve: 0 }, min: { reserve: 0 } }
                            }
                        Q2WindowDescriptor: undefined
                        }
                    ]
                    # / END: splitter stack
                }
                # / END: plane
            {
                id: "idSchemaDiagnosticsPlane"
                name: "Diagnostics"
                initialEnable: false
                splitterStack: [
                    {
                        id: "idDiagnosticsPlaneSplitter0"
                        name: "Diagnostics plane splitter"
                        type: "vertical"
                        Q1WindowDescriptor: {
                            id: "idSchemaBootStats"
                            name: "#{appName} App Boot Info"
                            initialMode: "full"
                            initialEnable: true
                            opacity: observableWindowDefaultOpacity
                            backgroundColor: "#992667"
                            overflow: "auto"
                            modes: { full: { reserve: 0 }, min: { reserve: 0 } }
                            MVVM: {
                                fnModelView: -> Encapsule.runtime.app.SchemaBootInfoWindow
                                viewModelTemplateId: "idKoTemplate_SchemaBootInfoWindow"
                                }

                            }
                        Q2WindowDescriptor: undefined
                        }
                    ]
                    # / END: splitter stack
                }
                # / END: plane

            ]
            # END: / plane array
        }
        # / END: Encapsule.code.app.viewLayout
catch exception
    alert("Load-time parse error in window manager layout declaration: #{exception}")