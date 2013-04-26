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
# schema-window-manager-layout-root-plane-home.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.winmgr = Encapsule.code.app.winmgr? and Encapsule.code.app.winmgr or @Encapsule.code.app.winmgr = {}
Encapsule.code.app.winmgr.layout = Encapsule.code.app.winmgr.layout? and Encapsule.code.app.winmgr.layout or @Encapsule.code.app.winmgr.layout = {}
Encapsule.code.app.winmgr.layout.root = Encapsule.code.app.winmgr.layout.root? and Encapsule.code.app.winmgr.layout.root or @Encapsule.code.app.winmgr.layout.root = {}

CommonSettings = Encapsule.code.app.winmgr.layout.CommonSettings

Encapsule.code.app.winmgr.layout.root.PlaneCatalogue = {
    id: "idRootPlaneCatalogue"
    name: "Catalogue"
    initialEnable: false
    splitterStack: [

        Encapsule.code.app.winmgr.layout.PlaneSelectSplitter

        {                                                                    
            id: "idTitleBarSplitter"
            name: "Title Bar Split"                                            
            type: "horizontal"                                               
            Q1WindowDescriptor: undefined                                    
            Q2WindowDescriptor: {
                id: "idContent"
                name: "Catalogue Setup"
                initialMode: "full"
                initialEnable: true
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: "#999999"
                modes: { full: { reserve: 100 }, min: { reserve: 0 } }
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
                initialEnable: true
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: undefined
                overflow: "auto"
                modes: { full: { reserve: 1024 }, min: { reserve: 200 } }
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
            opacity: CommonSettings.windowOpacityDefault
            backgroundColor: "white"
            modes: { full: { reserve: 0 }, min: { reserve: 128 } }
            MVVM: {
                fnModelView: -> Encapsule.runtime.app.SchemaScdlCatalogue
                viewModelTemplateId: "idKoTemplate_ScdlCatalogueJSONSourceView"
                }
            }
        }







    ]
} # PlaneCatalogue
