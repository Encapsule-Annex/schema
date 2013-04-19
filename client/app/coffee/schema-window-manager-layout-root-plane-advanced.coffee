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

Encapsule.code.app.winmgr.layout.root.PlaneAdvanced = {



    id: "idSchemaPlaneDefault"
    name: "Advanced"
    initialEnable: true
    splitterStack: [



        {                                                                    
            id: "idCatalogueNavigatorSplitter"
            name: "SCDL Catalogue Navigator Splitter"                                           
            type: "vertical"                                                 
            Q1WindowDescriptor: {                                            
                id: "idScdlCatalogueNavigator"                                              
                name: "SCDL Catalogue Navigator"                                      
                initialMode: "full"
                initialEnable: true
                overflow: "auto"
                opacity: 1.0
                backgroundColor: "#0099CC"
                modes: { full: { reserve: 212 }, min: { reserve: 32 } }
                MVVM: {
                    modelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigator"
                }
            }                                                            
            Q2WindowDescriptor: undefined                                    
        }

        Encapsule.code.app.winmgr.layout.PlaneSelectSplitter

        {                                                                    
            id: "idCatalogueNavigatorPathSplitter"
            name: "SCDL Catalogue Navigator Path Split"                                           
            type: "horizontal"                                                 
            Q1WindowDescriptor: {                                            
                id: "idScdlCatalogueNavigatorPath"                                              
                name: "SCDL Catalogue Navigator Path"                                      
                initialMode: "full"
                initialEnable: true
                overflow: "hidden"
                opacity: 1.0
                backgroundColor: "#99FFFF"
                modes: { full: { reserve: 14 }, min: { reserve: 14 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigatorPathWindow"
                }
            }                                                            
            Q2WindowDescriptor: undefined                                    
        }

        {
            id: "idCatlogueJSONSplitter"
            name: "Catlogue JSON Split"                                        
            type: "vertical"                                                 
            Q1WindowDescriptor: undefined                                    
            Q2WindowDescriptor: {                                            
            id: "idCatalogueJSON"                                           
            name: "SCDL Catalogue JSON"
            initialMode: "full"
            initialEnable: false
            overflow: "auto"
            opacity: CommonSettings.windowOpacityDefault
            backgroundColor: undefined
            modes: { full: { reserve: 400 }, min: { reserve: 128 } }
            MVVM: {
                fnModelView: -> Encapsule.runtime.app.SchemaScdlCatalogue
                viewModelTemplateId: "idKoTemplate_ScdlCatalogueJSONSourceView"
                }
            }
        }





        {                                                                    
            id: "idSelect2Splitter"
            name: "Select 2 Split"                                           
            type: "vertical"                                                 
            Q1WindowDescriptor: {                                            
                id: "idSelect2"                                              
                name: "Select 1 Window"                                      
                initialMode: "full"
                initialEnable: false
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: undefined
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
        }




        {                                                                    
            id: "idEditSplitter"
            name: "Edit Split"                                           
            type: "horizontal"                                               
            Q1WindowDescriptor: {
                id: "idView1"
                name: "View 1 Window"
                initialEnable: false
                initialMode: "full"
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: "white"
                modes: { full: { reserve: 0}, min: { reserve: 0 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaEditorContext
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelScdlBrowserCatalogues"
                }
            }
            Q2WindowDescriptor: {                                            
                id: "idEdit1"                                                
                name: "Edit 1 Window"                                        
                initialMode: "full"
                initialEnable: true
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: "#00CCFF"
                modes: { full: { reserve: 0 }, min: { reserve: 32 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigatorBrowserWindow"

                }
            }                                                            
        }


    ] # / END: splitter stack

} # PlaneAdvanced
