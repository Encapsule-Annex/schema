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
# schema-window-manager-layout-plane-onmjs-data-model.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.winmgr = Encapsule.code.app.winmgr? and Encapsule.code.app.winmgr or @Encapsule.code.app.winmgr = {}
Encapsule.code.app.winmgr.layout = Encapsule.code.app.winmgr.layout? and Encapsule.code.app.winmgr.layout or @Encapsule.code.app.winmgr.layout = {}
Encapsule.code.app.winmgr.layout.root = Encapsule.code.app.winmgr.layout.root? and Encapsule.code.app.winmgr.layout.root or @Encapsule.code.app.winmgr.layout.root = {}

CommonSettings = Encapsule.code.app.winmgr.layout.CommonSettings

Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
schemaRuntime = Encapsule.runtime.app
ONMjsRuntime = schemaRuntime.ONMjs? and schemaRuntime.ONMjs or schemaRuntime.ONMjs = {}
ONMjsRuntime.observers = ONMjsRuntime.observers? and ONMjsRuntime.observers or ONMjsRuntime.observers = {}
ONMjsRuntime.observers.onmjs = ONMjsRuntime.observers.onmjs? and ONMjsRuntime.observer.onmjs or ONMjsRuntime.observers.onmjs = {}


Encapsule.code.app.winmgr.layout.root.PlaneONMjsEditor = {

    id: "idSchemaPlaneONMjsEditor"
    name: "ONMjs Editor"
    initialEnable: false
    splitterStack: [
        {
            id: "idONMjsEditorSplit1"
            name: "Split 1"
            type: "horizontal"
            Q1WindowDescriptor: {
                id: "idONMjsEditorPathWindow"
                name: "ONMjs Editor Path Window"
                initialMode: "min"
                initialEnable: true
                overflow: "hidden"
                opacity: 1.0
                backgroundColor: "rgba(0,255,0, 0.2)"
                modes: { full: { reserve: 64 }, min: { reserve: 16 } }
                MVVM: {
                    fnModelView: -> ONMjsRuntime.observers.onmjs.path
                    viewModelTemplateId: "idKoTemplate_SelectedPathViewModel"
                }
            }
            Q2WindowDescriptor: undefined
        }

        Encapsule.code.app.winmgr.layout.PlaneSelectSplitterHorizontalBottom

        {                                                                    
            id: "idONMjsEditorSplit2"
            name: "Split 2"
            type: "vertical"                                                 
            Q1WindowDescriptor: {                                            
                id: "idONMjsEditorNavigatorWindow"
                name: "ONMjs Editor Navigator Window"
                initialMode: "min"
                initialEnable: true
                overflow: "auto"
                opacity: 1.0
                backgroundColor: undefined
                modes: { full: { reserve: 450 }, min: { reserve: 350 } }

                MVVM: {
                    fnModelView: -> ONMjsRuntime.observers.onmjs.navigator
                    viewModelTemplateId: "idKoTemplate_NavigatorViewModel"
                }

            }                                                            
            Q2WindowDescriptor: undefined                                    
        }

        {
            id: "idONMjsEditorSplit3A"
            name: "Spit 3"
            type: "vertical"
            Q1WindowDescriptor: undefined
            Q2WindowDescriptor: {                                            
                id: "idONMjsEditorCompiledJSONWindow"
                name: "Is this really necessary?"
                initialMode: "min"
                initialEnable: true
                opacity: 1.0
                overflow: "auto"
                modes: {full: { reserve: 500 }, min: { reserve: 250} }
                MVVM: {
                    fnModelView: -> ONMjsRuntime.observers.onmjs.dragonEggCompiler
                    viewModelTemplateId: "idKoTemplate_DragonEggCompilerView"
                }
            }
        }   


        {
            id: "idONMjsEditorSplit3"
            name: "Spit 3"
            type: "vertical"
            Q1WindowDescriptor: undefined
            Q2WindowDescriptor: {                                            
                id: "idONMjsEditorJSONWindow"
                name: "ONMjs Editor JSON Window"
                initialMode: "min"
                initialEnable: true
                overflow: "auto"
                opacity: 1.0
                backgroundColor: "rgba(255,255,255,0.1)"
                modes: { full: { reserve: 500 }, min: { reserve: 250 } }
                MVVM: {
                    fnModelView: -> ONMjsRuntime.observers.onmjs.json
                    viewModelTemplateId: "idKoTemplate_ObjectModelNavigatorJsonModelView"

                }
            }
        }   

        {                                                                    
            id: "idONMjsEditorSplit4"
            name: "Split 4"
            type: "horizontal"                                                 
            Q1WindowDescriptor: {                                            
                id: "idONMjsEditorNamespaceWindow"
                name: "ONMjs Editor Namespace Window"
                initialMode: "full"
                initialEnable: true
                opacity: 1.0
                overflow: "auto"
                backgroundColor:  "rgba(255,255,255,0.4)"
                modes: { full: { reserve: 0 }, min: { reserve: 0 } }
                MVVM: {
                    fnModelView: -> ONMjsRuntime.observers.onmjs.namespace
                    viewModelTemplateId: "idKoTemplate_SelectedNamespaceViewModel"
                }
            }

            Q2WindowDescriptor: undefined

        }

    ] # / END: splitter stack

} # PlaneAdvanced
