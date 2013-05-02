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



    id: "idSchemaPlaneScdlCatalogueNavigator"
    name: "Catalogue"
    initialEnable: false
    splitterStack: [



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
                backgroundColor: undefined
                modes: { full: { reserve: 800 }, min: { reserve: 330 } }
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
                backgroundColor: "#CCEEDD"
                modes: { full: { reserve: 400 }, min: { reserve: 200 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigatorJSONWindow"

                }
            }
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
                overflow: "auto"
                opacity: 1.0
                backgroundColor: "#FFFFCC"
                modes: { full: { reserve: 132 }, min: { reserve: 18 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigatorPathWindow"
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
                initialMode: "min"
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: "white"
                modes: { full: { reserve: 0}, min: { reserve: 40 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaEditorContext
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelScdlBrowserCatalogues"
                }
            }
            Q2WindowDescriptor: {                                            
                id: "idScdlNavigatorMenuItemWindow"                                                
                name: "SCDL Catalogue Item View"                                        
                initialMode: "full"
                initialEnable: true
                opacity: CommonSettings.windowOpacityDefault
                backgroundColor: "#FFFFEE"
                modes: { full: { reserve: 0 }, min: { reserve: 40 } }
                MVVM: {
                    fnModelView: -> Encapsule.runtime.app.SchemaScdlNavigatorWindow
                    viewModelTemplateId: "idKoTemplate_SchemaViewModelNavigatorBrowserWindow"

                }
            }                                                            
        }



    ] # / END: splitter stack

} # PlaneAdvanced
