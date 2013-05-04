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
# schema-scdl-navigator-window-layout.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

if not (net? and net and net.brehaut? and net.brehaut)
   throw "Missing color.js library."
Color = net.brehaut.Color

Encapsule.code.app.modelview.ScdlNavigatorWindowLayout = {

    jsonTag: "app"
    label: "#{appName} Root"
    description: "#{appName} Root State Namespace"

    detailBelowSelectDefault: 0
    detailAboveSelectDefault: 1

    initialSelectionPath: "app.schema"

    baseBackgroundColor: Color({ hue: 190, saturation: 1, value: 0.6}).toCSS()
    baseBackgroundRatioPercentPerLevel: 0

    borderLightRatio: 0.25
    borderDarkRatio: 0.30
    borderFlatRatio: -2
    borderWidth: 1 # default
    borderWidthOutset: 1
    borderWidthInset: 1
    borderWidthFlat: 1

    fontColorRatioDefault: 0.45
    fontColorRatioSelected: -0.8
    fontColorRatioSelectedChild: -0.8
    fontColorRatioMouseOver: -1
    
    selectedItemBackgroundShiftHue: 0
    selectedItemBackgroundLightenRatio: 0.15

    selectedChildItemBackgroundShiftHue: 0
    selectedChildItemBackgroundLightenRatio: 0.15

    mouseOverItemBackgroundShiftHue: -5
    mouseOverItemBackgroundLightenRatio: 0.3


    menuLevelPaddingTop: 1
    menuLevelPaddingBottom: 5
    menuLevelPaddingLeft: 5
    menuLevelPaddingRight: 5

    menuLevelFontSizeMax: 14
    menuLevelFontSizeMin: 12


    structureArrayShiftHue: 0
    structureArrayLightenRatio: 0.2

    metaArrayElementShiftHue: 0
    metaArrayElementLightenRatio: 0.2

    userObjectShiftHue: -60
    userObjectDarkenRatio: 0
    

    menuLevelBoxShadowColorDarkenRatio: 0.3 # Used as shadow color if mouse over or selection path
    menuLevelBoxShadowColorLightenRatio: 0.25

    menuLevelBoxShadowInSelectionPath: { type: "inset", xBase: 1, xPerLevel: 2, yBase: 1, yPerLevel: 2, blurBase: 15, blurPerLevel: 1 }
    menuLevelBoxShadowNotSelected: { type: "inset", x: 0, y: 10, blur: 10 }

    menuLevelBoxShadowMouseOverHighlight: { type: "inset", x: 1,  y: 1, blur:  5 }

    menuLevelBoxShadowMouseOverSelected: { type: "inset", x: 0, y: 0, blur: 0 } 


    externalIntegration: {
        fnNotifyPathChange: (navigatorContainer_, path_) ->
            # We currently instantiate the SchemaRouter after the navigator. The first selection change
            # will not be forwarded. That's okay.
            if Encapsule.runtime.app.SchemaRouter? and Encapsule.runtime.app.SchemaRouter
                Encapsule.runtime.app.SchemaRouter.setRoute(path_)
    }


    menuHierarchy: [
        {
            jsonTag: "schema"
            label: "#{appName}"
            objectDescriptor: {
                mvvmType: "child"
                description: "#{appName} App Root"
            }


            subMenus: [
                {
                    jsonTag: "Workstations"
                    label: "Workstations"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "Workstations are task-specific SCDL catalogue editors."
                    }
                    subMenus: [
                        {
                            jsonTag: "compose"
                            label: "Compose"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "SCDL system composer."
                            }
                        }

                        {
                            jsonTag: "design"
                            label: "Design"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "SCDL system designer."
                            }
                        }

                        {
                            jsonTag: "model"
                            label: "Model"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "SCDL model designer."
                            }
                        }
                        {
                            jsonTag: "test"
                            label: "Test"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "SCDL test bench."
                            }
                        }
                        {
                            jsonTag: "visualize"
                            label: "Visualize"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "SCDL model visualizer."
                            }
                        }
                        {
                            jsonTag: "share"
                            label: "Share"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "Share your work."
                            }
                        }
                    ] # tools submenus
                } # tools


                {
                    jsonTag: "catalogues"
                    label: "Catalogues"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "Manage SCDL catalogues in your local repository."
                    }
                    subMenus: [
                        {
                            jsonTag: "scdlCatalogueSelectHost"
                            label: "Selected Catalogue"
                            objectDescriptor: {
                                mvvmType: "select"
                                description: "Currently selected SCDL catalogue."
                            }
                        }
                        {
                            jsonTag: "scdlCatalogue"
                            label: "Catalogue"
                            objectDescriptor: {
                                mvvmType: "archetype"
                                description: "SCDL catalogue object archetype."
                            }
                            subMenus: [
                                {
                                    jsonTag: "specifications"
                                    label: "Specifications"
                                    objectDescriptor: {
                                        mvvmType: "extension"
                                        description: "SCDL specification."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "specification"
                                            label: "Specification"
                                            objectDescriptor: {
                                                mvvmType: "archetype"
                                                description: "SCDL specification."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "systemInstances"
                                                    label: "System Instances"
                                                    objectDescriptor: {
                                                        mvvmType: "extension"
                                                        description: "SCDL system model instances."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "systemInstance"
                                                            label: "System Instance"
                                                            objectDescriptor: {
                                                                mvvmType: "archetype"
                                                                description: "SCDL system model instance."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "socketInstances"
                                                                    label: "Socket Instances"
                                                                    objectDescriptor: {
                                                                        mvvmType: "extension"
                                                                        description: "SCDL socket model instances."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "socketInstance"
                                                                            label: "Socket Instance"
                                                                            objectDescriptor: {
                                                                                mvvmType: "archetype"
                                                                                description: "SCDL socket model instance." 
                                                                            }
                                                                            subMenus: [
                                                                                {
                                                                                    jsonTag: "instanceBindings"
                                                                                    label: "Instance Bindings"
                                                                                    objectDescriptor: {
                                                                                        mvvmType: "extension"
                                                                                        description: "SCDL socket model instance bindings."
                                                                                    }
                                                                                    subMenus: [
                                                                                        {
                                                                                            jsonTag: "instanceBinding"
                                                                                            label: "Instance Binding"
                                                                                            objectDescriptor: {
                                                                                                mvvmType: "archetype"
                                                                                                description: "SCDL socket model instance binding."
                                                                                            }
                                                                                        }
                                                                                    ] # Bindings submenus
                                                                                } # Bindings
                                                                            ] # Socket submenus
                                                                        }
                                                                    ] # Sockets submenus
                                                                } # 
                                                            ] # System submenus
                                                        } # System
                                                    ] # Systems submenus
                                                } # Systems
                                            ] # Specification submenus
                                        } # Specification
                                    ] # Specifications submenu
                                } # Specifications
                                {
                                    jsonTag: "models"
                                    label: "Models"
                                    objectDescriptor: {
                                        mvvmType: "child"
                                        description: "SCDL models by type."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "systems"
                                            label: "Systems"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL system models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "system"
                                                    label: "System"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL system model."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "pins"
                                                            label: "I/O Pins"
                                                            objectDescriptor: {
                                                                mvvmType: "child"
                                                                description: "SCDL pin models by function."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "inputPins"
                                                                    label: "Input Pins"
                                                                    objectDescriptor: {
                                                                        mvvmType: "extension"
                                                                        description: "SCDL input pin models."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "inputPin"
                                                                            label: "Input Pin"
                                                                            objectDescriptor: {
                                                                                mvvmType: "archetype"
                                                                                description: "SCDL input pin model."
                                                                            }
                                                                        } # Inputs submenus
                                                                    ] # Inputs submenus
                                                                } # Inputs
                                                                {
                                                                    jsonTag: "outputPins"
                                                                    label: "Output Pins"
                                                                    objectDescriptor: {
                                                                        mvvmType: "extension"
                                                                        description: "SCDL output pin models."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "outputPin"
                                                                            label: "Output Pin"
                                                                            objectDescriptor: {
                                                                                mvvmType: "archetype"
                                                                                description: "SCDL output pin model."
                                                                            }
                                                                        } # Output
                                                                    ] # Outputs submenus
                                                                } # Outputs
                                                            ] # Pins submenus
                                                        } # Pins
                                                        {
                                                            jsonTag: "models"
                                                            label: "Models"
                                                            objectDescriptor: {
                                                                mvvmType: "extension"
                                                                description: "SCDL model instances."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "model"
                                                                    label: "Model"
                                                                    objectDescriptor: {
                                                                        mvvmType: "archetype"
                                                                        description: "SCDL model instance."
                                                                    }
                                                                } #  Models submenus
                                                            ] # Models submenus
                                                        } # Models
                                                        {
                                                            jsonTag: "nodes"
                                                            label: "Nodes"
                                                            objectDescriptor: {
                                                                mvvmType: "extension"
                                                                description: "SCDL node descriptor instances."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "node"
                                                                    label: "Node"
                                                                    objectDescriptor: {
                                                                        mvvmType: "archetype"
                                                                        detail: "SCDL node descriptor instance."
                                                                    }
                                                                } # Node
                                                            ] # Nodes submenus
                                                        } # Nodes
                                                    ] # System submenus
                                                } # Systems submenus
                                            ] # Systems submenus
                                        } # Systems
                                        {
                                            jsonTag: "sockets"
                                            label: "Sockets"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL socket models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "socket"
                                                    label: "Socket"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL socket model."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "pins"
                                                            label: "I/O Pins"
                                                            objectDescriptor: {
                                                                mvvmType: "child"
                                                                description: "SCDL pin models by function."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "inputPins"
                                                                    label: "Input Pins"
                                                                    objectDescriptor: {
                                                                        mvvmType: "extension"
                                                                        description: "SCDL input pin models."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "inputPin"
                                                                            label: "Input Pin"
                                                                            objectDescriptor: {
                                                                                mvvmType: "archetype"
                                                                                description: "SCDL input pin model."
                                                                            }
                                                                        } # Inputs submenus
                                                                    ] # Inputs submenus
                                                                } # Inputs
                                                                {
                                                                    jsonTag: "outputPins"
                                                                    label: "Output Pins"
                                                                    objectDescriptor: {
                                                                        mvvmType: "extension"
                                                                        description: "SCDL output pin models."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "outputPin"
                                                                            label: "Output Pin"
                                                                            objectDescriptor: {
                                                                                mvvmType: "archetype"
                                                                                description: "SCDL output pin model."
                                                                            }
                                                                        } # Output
                                                                    ] # Outputs submenus
                                                                } # Outputs
                                                            ] # Pins submenus
                                                        } # Pins
                                                    ] # Socket submenus
                                                } # Socket
                                            ] # Sockets submenus
                                        } # Sockets
                                        {
                                            jsonTag: "contracts"
                                            label: "Contracts"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL contract models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "contract"
                                                    label: "Contract"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL contract model."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "socketReference"
                                                            label: "Socket Reference"
                                                            objectDescriptor: {
                                                                mvvmType: "child"
                                                                description: "SCDL socket reference."
                                                            }
                                                        }
                                                        {
                                                            jsonTag: "modelReference"
                                                            label: "Model Reference"
                                                            objectDescriptor: {
                                                                mvvmType: "child"
                                                                description: "SCDL model reference."
                                                            }
                                                        }
                                                        {   
                                                            jsonTag: "nodes"
                                                            label: "Nodes"
                                                            objectDescriptor: {
                                                                mvvmType: "extension"
                                                                description: "SCDL node instances."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "node"
                                                                    label: "Node"
                                                                    objectDescriptor: {
                                                                        mvvmType: "archetype"
                                                                        description: "SCDL node instance."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "sourcePin"
                                                                            label: "Source Pin"
                                                                            objectDescriptor: {
                                                                                mvvmType: "child"
                                                                                description: "SCDL source (i.e. output) pin model reference."
                                                                            }
                                                                        }
                                                                        {
                                                                            jsonTag: "sinkPins"
                                                                            label: "Sink Pins"
                                                                            objectDescriptor: {
                                                                                mvvmType: "extension"
                                                                                description: "SCDL sink (i.e. input) pin models."
                                                                            }
                                                                            subMenus: [
                                                                                {
                                                                                    jsonTag: "sinkPin"
                                                                                    label: "Sink Pin"
                                                                                    objectDescriptor: {
                                                                                        mvvmType: "archetype"
                                                                                        description: "SCDL sink (i.e. input) pin model reference."
                                                                                    }
                                                                                }
                                                                            ]
                                                                        }
                                                                    ]
                                                                } # Node
                                                            ] # Nodes submenus
                                                        } # Nodes
                                                    ] # Socket Contract submenus
                                                } # Socket Contract
                                            ] # Socket Contracts submenus
                                        } # Socket Contracts
        
                                        {
                                            jsonTag: "machines"
                                            label: "Machines"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL machine models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "machine"
                                                    label: "Machine"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL machine model."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "pins"
                                                            label: "I/O Pins"
                                                            objectDescriptor: {
                                                                mvvmType: "child"
                                                                description: "SCDL pins by function."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "inputPins"
                                                                    label: "Input Pins"
                                                                    objectDescriptor: {
                                                                        mvvmType: "extension"
                                                                        description: "SCDL input pin models."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "inputPin"
                                                                            label: "Input Pin"
                                                                            objectDescriptor: {
                                                                                mvvmType: "archetype"
                                                                                description: "SCDL input pin model."
                                                                            }
                                                                        } # Inputs submenus
                                                                    ] # Inputs submenus
                                                                } # Inputs
                                                                {
                                                                    jsonTag: "outputPins"
                                                                    label: "Output Pins"
                                                                    objectDescriptor: {
                                                                        mvvmType: "extension"
                                                                        description: "SCDL output pin models."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "outputPin"
                                                                            label: "Output Pin"
                                                                            objectDescriptor: {
                                                                                mvvmType: "archetype"
                                                                                description: "SCDL output pin model."
                                                                            }
                                                                        } # Output
                                                                    ] # Outputs submenus
                                                                } # Outputs
                                                            ] # Pins submenus
                                                        } # I/O Pins
                                                        {
                                                            jsonTag: "states"
                                                            label: "States"
                                                            objectDescriptor: {
                                                                mvvmType: "extension"
                                                                description: "SCDL state descriptors."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "state"
                                                                    label: "State"
                                                                    objectDescriptor: {
                                                                        mvvmType: "archetype"
                                                                        description: "SCDL state descriptor."
                                                                    }
                                                                } # State
                                                            ] # States submenus
                                                        } # States
                                                        {
                                                            jsonTag: "transitions"
                                                            label: "Transitions"
                                                            objectDescriptor: {
                                                                mvvmType: "extension"
                                                                description: "SCDL state transition descriptors."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "transition"
                                                                    label: "Transition"
                                                                    objectDescriptor: {
                                                                        mvvmType: "archetype"
                                                                        description: "SCDL state transition descriptor."
                                                                    }
                                                                } # Transition
                                                            ] # Transitions submenus
                                                        } # Transitions
                                                        {
                                                            jsonTag: "actions"
                                                            label: "Actions"
                                                            objectDescriptor: {
                                                                mvvmType: "extension"
                                                                description: "SCDL state transition action descriptors."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "action"
                                                                    label: "Action"
                                                                    objectDescriptor: {
                                                                        mvvmType: "archetype"
                                                                        description: "SCDL state transition action descriptor."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "entryAction"
                                                                            label: "Entry Action"
                                                                            objectDescriptor: {
                                                                                mvvmType: "child"
                                                                                description: "SCDL state transition entry action descriptor."
                                                                            }
                                                                        }
                                                                        {
                                                                            jsonTag: "exitAction"
                                                                            label: "Exit Action"
                                                                            objectDescriptor: {
                                                                                mvvmType: "child"
                                                                                description: "SCDL state transition exit action descriptor."
                                                                            }
                                                                        }
                                                                    ] # Action submenus
                                                                } # Action
                                                            ] # Actions submenus
                                                        } # Actions
                                                    ] # Machine submenus
                                                } # Machine
                                            ] # Machines submenus
                                        } # Machines
                                        {
                                            jsonTag: "types"
                                            label: "Types"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL type models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "type"
                                                    label: "Type"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL type model."
                                                    }
                                                } # Type
                                            ] # Types submenus
                                        } # Types
        
                                    ] # Models submenus
                                } # Models
                                {
                                    jsonTag: "assets"
                                    label: "Assets"
                                    objectDescriptor: {
                                        mvvmType: "child"
                                        description: "SCDL asset models by namespace."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "people"
                                            label: "People"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL person models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "person"
                                                    label: "Person"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL person model."
                                                    }
                                                } # Person
                                            ] # People submenus
                                        } # People
                                        {
                                            jsonTag: "organizations"
                                            label: "Organizations"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL organization models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "organization"
                                                    label: "Organization"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL organization model."
                                                    }
                                                }
                                            ] # Organizations submenus
                                        } # Organizations
                                        {
                                            jsonTag: "licenses"
                                            label: "Licenses"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL license models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "license"
                                                    label: "License"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL license model."
                                                    }
                                                } # Licesne
                                            ] # Licesnes submenus
                                        } # Licenses
                                        {
                                            jsonTag: "copyrights"
                                            label: "Copyrights"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "SCDL copyright models."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "copyright"
                                                    label: "Copyright"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "SCDL copyright model."
                                                    }
                                                } # Copyright
                                            ] # Copyrights submenus
                                        } # Copyrights
                                    ] # Assets submenu
                                } # Assets
                            ] # Catalogue submenu
                        } # Catalogue
                    ]
                } # catalogueManager


                {
                    jsonTag: "sessions"
                    label: "Sessions"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "Manager current and past session."
                    }
                    subMenus: [
                        {
                            jsonTag: "session"
                            label: "Session"
                            objectDescriptor: {
                                mvvmType: "archetype"
                                description: "#{appName} session object."
                            }
                        }
                    ] # sessionManager submenus
                } # sessionManager



                {
                    jsonTag: "settings"
                    label: "Settings"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "#{appName} app settings."
                    }
                    subMenus: [
                        {
                            jsonTag: "user"
                            label: "User"
                            objectDescriptor: {
                                mvvmType: "child"
                            }
                        }
                        {
                            jsonTag: "preferences"
                            label: "Preferences"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "App preferences."
                            }
                            subMenus: [
                                {
                                    jsonTag: "app"
                                    label: "App"
                                    objectDescriptor: {
                                        mvvmType: "child"
                                        description: "#{appName} app preferences."
                                    }
                                }
                                {
                                    jsonTag: "github"
                                    label: "GitHub"
                                    objectDescriptor: {
                                        mvvmType: "child"
                                        description: "GitHub integration preferences."
                                    }
                                }
                            ]
                        }
                        {
                            jsonTag: "advanced"
                            label: "Advanced"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "Advanced app settings."
                            }
                            subMenus: [
                                {
                                    jsonTag: "baseScdlCatalogue"
                                    label: "Base Catalogue"
                                    objectDescriptor: {
                                        mvvmType: "child"
                                        description: "SCDL catalogue archetype."
                                    }
                                }
                                {
                                    jsonTag: "storage"
                                    label: "Storage"
                                    objectDescriptor: {
                                        mvvmType: "child"
                                        description: "App local and remote storage."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "local"
                                            label: "Local"
                                            objectDescriptor: {
                                                mvvmType: "child"
                                                description: "App local storage."
                                            }
                                        } # local
                                        {
                                            jsonTag: "remotes"
                                            label: "Remotes"
                                            objectDescriptor: {
                                                mvvmType: "extension"
                                                description: "Remote stores."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "source"
                                                    label: "Source"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "Source descriptor for remote SCDL catalogue(s)."
                                                    }
                                                } # remote
                                            ] # remotes submenus
                                        } # remotes
                                    ] # storage submenus
                                } # storage
                            ] # advanced submenus
                        } # advanced
                    ] # settings submenus
                } # settings

                {
                    jsonTag: "about"
                    label: "About"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "About namespace."
                    }
                    subMenus: [
                        {
                            jsonTag: "status"
                            label: "Status"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "Current app status."
                            }
                        }
                        {
                            jsonTag: "version"
                            label: "v#{appVersion}"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "#{appName} v#{appVersion} notes."
                            }
                            subMenus: [
                                {
                                    jsonTag: "build"
                                    label: "Build Info"
                                    objectDescriptor: {
                                        mvvmType: "child"
                                        description: "Information about build #{appBuildId}"
                                    }
                                }
                                {
                                    jsonTag: "diagnostic"
                                    label: "Diagnostic"
                                    objectDescriptor: {
                                        mvvmType: "child"
                                        description: "Advanced diagnostic information."
                                    }
                                }
                            ]
                        }
                        {
                            jsonTag: "publisher"
                            label: appPackagePublisher
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "About the #{appPackagePublisher}"
                            }
                        }
                    ] # about submenus
                } # about

                {
                    jsonTag: "help"
                    label: "Help"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "#{appName} help."
                    }
                }


            ] # Schema submenus
        } # Schema

    ] # ScdlNavigatorWindowLayout
} # layout object    
    

