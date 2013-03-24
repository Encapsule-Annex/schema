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
    layout: {
        # Layout metadata
        id: "idSchemaWindowManager"
        name: "#{appName} v#{appVersion} Window Manager"

        # Attributes of whatever element we're hosted in. (Mostly the BODY)
        pageBackgroundColor: undefined
        glassBackgroundColor: undefined
        windowManagerBackgroundColor: "white"

        # Margin attributes
        glassMargin: 0 # document edge to glass edge
        windowManagerMargin: 10 # glass edge to window manager edge

        # Background image attributes

        #glassBackgroundImage: "fire-on-the-mountain.jpg"
        glassBackgroundImage: "Aspen_trees_2.jpg"

        # Opacity attributes
        glassOpacity: 0.6
        windowManagerOpacity: 0.5

        windowManagerFadeInTimeout: 1500


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
                            modes: { full: { reserve: 0 }, min: { reserve: 0 } }         
                            }                                                            
                        Q2WindowDescriptor: {                                            
                            id: "idEdit1"                                                
                            name: "Edit 1 Window"                                        
                            modes: { full: { reserve: 0 }, min: { reserve: 64 } }        
                            }                                                            
                        }                                                                

                    ]
                },
                # end plane / new plane
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
                            modes: { full: { reserve: 0 }, min: { reserve: 0 } }
                            }
                        Q2WindowDescriptor: {
                            id: "idSettings2"
                            name: "Settings 2 Window"
                            modes: { full: { reserve: 0 }, min: { reserve: 0 } }
                            }
                        }
                    ]
                }
            ] # end planes
        } # end layout
    } # end viewLayout
