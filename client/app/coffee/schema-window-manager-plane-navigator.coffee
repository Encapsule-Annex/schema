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
# schema-window-manager-layout-plane-navigator.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.winmgr = Encapsule.code.app.winmgr? and Encapsule.code.app.winmgr or @Encapsule.code.app.winmgr = {}
Encapsule.code.app.winmgr.layout = Encapsule.code.app.winmgr.layout? and Encapsule.code.app.winmgr.layout or @Encapsule.code.app.winmgr.layout = {}
Encapsule.code.app.winmgr.layout.root = Encapsule.code.app.winmgr.layout.root? and Encapsule.code.app.winmgr.layout.root or @Encapsule.code.app.winmgr.layout.root = {}

CommonSettings = Encapsule.code.app.winmgr.layout.CommonSettings

Encapsule.code.app.winmgr.layout.root.PlaneAdvanced = {



    id: "idSchemaPlaneScdlCatalogueNavigator"
    name: "Navigator"
    initialEnable: false
    splitterStack: [

        Encapsule.code.app.winmgr.layout.PlaneSelectSplitterHorizontalBottom

        {                                                                    
            id: "idCatalogueNavigatorSplitter"
            name: "SCDL Catalogue Navigator Splitter"                                           
            type: "vertical"                                                 
            Q1WindowDescriptor: {                                            
                id: "idScdlCatalogueNavigator"                                              
                name: "SCDL Catalogue Navigator"                                      
                initialMode: "min"
                initialEnable: true
                overflow: "auto"
                opacity: 1.0
                backgroundColor: "rgba(0,100,160,0.05)" # undefined
                modes: { full: { reserve: 450 }, min: { reserve: 350 } }
                MVVM: {
                    modelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigator"
                }
            }                                                            
            Q2WindowDescriptor: undefined                                    
        }

        {
            id: "idCatalogueNavigatorJsonSplitter"
            name: "SCDL Catalogue Navigator JSON Splitter"
            type: "vertical"
            Q1WindowDescriptor: undefined
            Q2WindowDescriptor: {                                            
                id: "idScdlNavigatorMenuItemJSONWindow"                                                
                name: "SCDL Catalogue Item JSON View"                                        
                initialMode: "full"
                initialEnable: true
                overflow: "auto"
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: "rgba(0,100,160,0.05)" # "rgba(0,255,204,0.1)"
                modes: { full: { reserve: 500 }, min: { reserve: 250 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigatorJSONWindow"

                }
            }
        }   


        {                                                                    
            id: "idSchemaNavigatorSelectedItemWindowSplitter"
            name: "Schema Navigator Selected Item Meta Window Splitter"
            type: "horizontal"                                                 
            Q1WindowDescriptor: {                                            
                id: "idSchemaNavigatorSelectedItemWindow"                                     
                name: "Schema Navigator Selected Item"                               
                initialMode: "full"
                initialEnable: true
                opacity: CommonSettings.windowOpacityDefault
                overflow: "auto"
                backgroundColor:  "rgba(255,255,255,0.1)"
                modes: { full: { reserve: 0 }, min: { reserve: 400 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    # Template defined in encapsule-lib-navigator-item-host-window.coffee
                    viewModelTemplateId: "idKoTemplate_SchemaNavigatorSelectedItemWindow"
                }
            }

            Q2WindowDescriptor: {                                            
                id: "idSchemaNavigatorSelectedItemMetaWindow"
                name: "Selected Item Meta"                              
                initialMode: "min"
                initialEnable: true
                overflow: "hide"
                opacity: 1.0
                backgroundColor: "rgba(0,100,160,0.25)"
                modes: { full: { reserve: 0 }, min: { reserve: 18 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    # schema-model-window-scdl-navigator-aux.coffee
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelSchemaNavigatorSelectedItemMetaWindow"
                }
            }                                                            
        }

    ] # / END: splitter stack

} # PlaneAdvanced
