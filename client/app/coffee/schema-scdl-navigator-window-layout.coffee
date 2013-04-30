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

    title: "SCDL Catalogue"

    baseBackgroundColor: Color({ hue: 190, saturation: 1, value: 0.7}).toCSS()
    baseBackgroundRatioPercentPerLevel: 0

    borderLightRatio: 0.2
    borderDarkRatio: 0.4
    borderFlatRatio: -1
    borderWidth: 1 # default
    borderWidthOutset: 1
    borderWidthInset: 1
    borderWidthFlat: 1

    fontColorRatioDefault: 1
    fontColorRatioSelected: -1
    fontColorRatioSelectedChild: -1
    fontColorRatioMouseOver: 1
    
    selectedItemBackgroundShiftHue: 0
    selectedItemBackgroundLightenRatio: -0.3

    selectedChildItemBackgroundShiftHue: 0
    selectedChildItemBackgroundLightenRatio: -0.3

    mouseOverItemBackgroundShiftHue: 0
    mouseOverItemBackgroundLightenRatio: -0.3


    menuLevelPaddingTop: 1
    menuLevelPaddingBottom: 5
    menuLevelPaddingLeft: 5
    menuLevelPaddingRight: 5

    menuLevelFontSizeMax: 14
    menuLevelFontSizeMin: 10

    structureArrayShiftHue: 0
    structureArrayLightenRatio: 0.2

    userObjectShiftHue: -20
    userObjectDarkenRatio: 0

    

    menuLevelBoxShadowColorDarkenRatio: 0.2 # Used as shadow color if mouse over or selection path
    menuLevelBoxShadowColorLightenRatio: 0.2

    menuLevelBoxShadowInSelectionPath: { type: "inset", xBase: 1, xPerLevel: 1, yBase: 1, yPerLevel: 1, blurBase: 5, blurPerLevel: 1 }
    menuLevelBoxShadowNotSelected: { type: "inset", x: 0, y: 2, blur: 10 }

    menuLevelBoxShadowMouseOverHighlight: { type: "inset", x: 3,  y: 3, blur:  3 }

    menuLevelBoxShadowMouseOverSelected: { normal: { type: "inset", x: 0, y: 0, blur: 0 }, explode: { type: "inset", x: 0, y: 10, blur: 25 } }


    menuHierarchy: [
        {
            jsonTag: "test"
            label: "Test Level"
            objectDescriptor: {
                type: "object"
                origin: "new"
                classification: "structure"
                description: "top-level menu item for testing collapsable menus."
            }
        }
        {
            jsonTag: "schema"
            label: appName
            objectDescriptor: {
                type: "object"
                origin: "new"
                classification: "structure"
                role: "namespace"
                description: "#{appName} root namespace object."
            }
            subMenus: [
                {
                    jsonTag: "scdlCatalogue"
                    label: "SCDL Catalogue"
                    objectDescriptor: {
                        type: "object"
                        origin: "parent"
                        classification: "structure"
                        role: "namespace"
                        description: "SCDL catalogue."
                    }
                    subMenus: [
                        {
                            jsonTag: "specifications"
                            label: "Specifications"
                            objectDescriptor: {
                                type: "array"
                                origin: "parent"
                                classification: "structure"
                                role: "extension"
                                description: "SCDL specification."
                            }
                            subMenus: [
                                {
                                    jsonTag: "specification"
                                    label: "Specification"
                                    objectDescriptor: {
                                        type: "object"
                                        origin: "user"
                                        classification: "mutable"
                                        role: "namespace"
                                        description: "SCDL specification."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "systemInstances"
                                            label: "System Instances"
                                            objectDescriptor: {
                                                type: "array"
                                                origin: "parent"
                                                classification: "structure"
                                                role: "extension"
                                                description: "SCDL system model instances."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "systemInstance"
                                                    label: "System Instance"
                                                    objectDescriptor: {
                                                        type: "object"
                                                        origin: "user"
                                                        classification: "mutable"
                                                        role: "namespace"
                                                        description: "SCDL system model instance."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "socketInstances"
                                                            label: "Socket Instances"
                                                            objectDescriptor: {
                                                                type: "array"
                                                                origin: "parent"
                                                                classification: "structure"
                                                                role: "extension"
                                                                description: "SCDL socket model instances."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "socketInstance"
                                                                    label: "Socket Instance"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "user"
                                                                        classification: "mutable"
                                                                        role: "namespace"
                                                                        description: "SCDL socket model instance." 
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "instanceBindings"
                                                                            label: "Instance Bindings"
                                                                            objectDescriptor: {
                                                                                type: "array"
                                                                                origin: "parent"
                                                                                classification: "structure"
                                                                                role: "extension"
                                                                                description: "SCDL socket model instance bindings."
                                                                            }
                                                                            subMenus: [
                                                                                {
                                                                                    jsonTag: "instanceBinding"
                                                                                    label: "Instance Binding"
                                                                                    objectDescriptor: {
                                                                                        type: "object"
                                                                                        origin: "user"
                                                                                        classification: "mutable"
                                                                                        role: "namespace"
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
                                type: "object"
                                origin: "parent"
                                classification: "structure"
                                role: "namespace"
                                description: "SCDL models by type."
                            }
                            subMenus: [
                                {
                                    jsonTag: "systems"
                                    label: "Systems"
                                    objectDescriptor: {
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL system models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "system"
                                            label: "System"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
                                                description: "SCDL system model."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "pins"
                                                    label: "I/O Pins"
                                                    objectDescriptor: {
                                                        type: "object"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "namepspace"
                                                        description: "SCDL pin models by function."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "inputPins"
                                                            label: "Input Pins"
                                                            objectDescriptor: {
                                                                type: "array"
                                                                origin: "parent"
                                                                classification: "structure"
                                                                role: "extension"
                                                                description: "SCDL input pin models."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "inputPin"
                                                                    label: "Input Pin"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "user"
                                                                        classification: "mutable"
                                                                        role: "namespace"
                                                                        description: "SCDL input pin model."
                                                                    }
                                                                } # Inputs submenus
                                                            ] # Inputs submenus
                                                        } # Inputs
                                                        {
                                                            jsonTag: "outputPins"
                                                            label: "Output Pins"
                                                            objectDescriptor: {
                                                                type: "array"
                                                                origin: "parent"
                                                                classification: "structure"
                                                                role: "extension"
                                                                description: "SCDL output pin models."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "outputPin"
                                                                    label: "Output Pin"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "user"
                                                                        classification: "mutable"
                                                                        role: "namespace"
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
                                                        type: "array"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "extension"
                                                        description: "SCDL model instances."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "model"
                                                            label: "Model"
                                                            objectDescriptor: {
                                                                type: "object"
                                                                origin: "user"
                                                                classification: "mutable"
                                                                role: "namespace"
                                                                description: "SCDL model instance."
                                                            }
                                                        } #  Models submenus
                                                    ] # Models submenus
                                                } # Models
                                                {
                                                    jsonTag: "nodes"
                                                    label: "Nodes"
                                                    objectDescriptor: {
                                                        type: "array"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "extension"
                                                        description: "SCDL node descriptor instances."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "node"
                                                            label: "Node"
                                                            objectDescriptor: {
                                                                type: "object"
                                                                origin: "user"
                                                                classification: "mutable"
                                                                role: "namespace"
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
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL socket models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "socket"
                                            label: "Socket"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
                                                description: "SCDL socket model."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "pins"
                                                    label: "I/O Pins"
                                                    objectDescriptor: {
                                                        type: "object"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "namespace"
                                                        description: "SCDL pin models by function."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "inputPins"
                                                            label: "Input Pins"
                                                            objectDescriptor: {
                                                                type: "array"
                                                                origin: "parent"
                                                                classification: "structure"
                                                                role: "extension"
                                                                description: "SCDL input pin models."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "inputPin"
                                                                    label: "Input Pin"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "user"
                                                                        classification: "mutable"
                                                                        role: "namespace"
                                                                        description: "SCDL input pin model."
                                                                    }
                                                                } # Inputs submenus
                                                            ] # Inputs submenus
                                                        } # Inputs
                                                        {
                                                            jsonTag: "outputPins"
                                                            label: "Output Pins"
                                                            objectDescriptor: {
                                                                type: "array"
                                                                origin: "parent"
                                                                classification: "structure"
                                                                role: "extension"
                                                                description: "SCDL output pin models."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "outputPin"
                                                                    label: "Output Pin"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "user"
                                                                        classification: "mutable"
                                                                        role: "namespace"
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
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL contract models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "contract"
                                            label: "Contract"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
                                                description: "SCDL contract model."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "socketReference"
                                                    label: "Socket Reference"
                                                    objectDescriptor: {
                                                        type: "object"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "namespace"
                                                        description: "SCDL socket reference."
                                                    }
                                                }
                                                {
                                                    jsonTag: "modelReference"
                                                    label: "Model Reference"
                                                    objectDescriptor: {
                                                        type: "object"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "namespace"
                                                        description: "SCDL model reference."
                                                    }
                                                }
                                                {   
                                                    jsonTag: "nodes"
                                                    label: "Nodes"
                                                    objectDescriptor: {
                                                        type: "array"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "extension"
                                                        description: "SCDL node instances."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "node"
                                                            label: "Node"
                                                            objectDescriptor: {
                                                                type: "object"
                                                                origin: "user"
                                                                classification: "mutable"
                                                                role: "namespace"
                                                                description: "SCDL node instance."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "sourcePin"
                                                                    label: "Source Pin"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "parent"
                                                                        classification: "structure"
                                                                        role: "namespace"
                                                                        description: "SCDL source (i.e. output) pin model reference."
                                                                    }
                                                                }
                                                                {
                                                                    jsonTag: "sinkPins"
                                                                    label: "Sink Pins"
                                                                    objectDescriptor: {
                                                                        type: "array"
                                                                        origin: "parent"
                                                                        classification: "structure"
                                                                        role: "extension"
                                                                        description: "SCDL sink (i.e. input) pin models."
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            jsonTag: "sinkPin"
                                                                            label: "Sink Pin"
                                                                            objectDescriptor: {
                                                                                type: "object"
                                                                                origin: "user"
                                                                                classification: "mutable"
                                                                                role: "namespace"
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
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL machine models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "machine"
                                            label: "Machine"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
                                                description: "SCDL machine model."
                                            }
                                            subMenus: [
                                                {
                                                    jsonTag: "pins"
                                                    label: "I/O Pins"
                                                    objectDescriptor: {
                                                        type: "object"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "namespace"
                                                        description: "SCDL pins by function."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "inputPins"
                                                            label: "Input Pins"
                                                            objectDescriptor: {
                                                                type: "array"
                                                                origin: "parent"
                                                                classification: "structure"
                                                                role: "extension"
                                                                description: "SCDL input pin models."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "inputPin"
                                                                    label: "Input Pin"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "user"
                                                                        classification: "mutable"
                                                                        role: "namespace"
                                                                        description: "SCDL input pin model."
                                                                    }
                                                                } # Inputs submenus
                                                            ] # Inputs submenus
                                                        } # Inputs
                                                        {
                                                            jsonTag: "outputPins"
                                                            label: "Output Pins"
                                                            objectDescriptor: {
                                                                type: "array"
                                                                origin: "parent"
                                                                classification: "structure"
                                                                role: "extension"
                                                                description: "SCDL output pin models."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "outputPin"
                                                                    label: "Output Pin"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "user"
                                                                        classification: "mutable"
                                                                        role: "namespace"
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
                                                        type: "array"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "extension"
                                                        description: "SCDL state descriptors."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "state"
                                                            label: "State"
                                                            objectDescriptor: {
                                                                type: "object"
                                                                origin: "user"
                                                                classification: "mutable"
                                                                role: "namespace"
                                                                description: "SCDL state descriptor."
                                                            }
                                                        } # State
                                                    ] # States submenus
                                                } # States
                                                {
                                                    jsonTag: "transitions"
                                                    label: "Transitions"
                                                    objectDescriptor: {
                                                        type: "array"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "extension"
                                                        description: "SCDL state transition descriptors."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "transition"
                                                            label: "Transition"
                                                            objectDescriptor: {
                                                                type: "object"
                                                                origin: "user"
                                                                classification: "mutable"
                                                                role: "namespace"
                                                                description: "SCDL state transition descriptor."
                                                            }
                                                        } # Transition
                                                    ] # Transitions submenus
                                                } # Transitions
                                                {
                                                    jsonTag: "actions"
                                                    label: "Actions"
                                                    objectDescriptor: {
                                                        type: "array"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "extension"
                                                        description: "SCDL state transition action descriptors."
                                                    }
                                                    subMenus: [
                                                        {
                                                            jsonTag: "action"
                                                            label: "Action"
                                                            objectDescriptor: {
                                                                type: "object"
                                                                origin: "user"
                                                                classification: "mutable"
                                                                role: "namespace"
                                                                description: "SCDL state transition action descriptor."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    jsonTag: "entryAction"
                                                                    label: "Entry Action"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "parent"
                                                                        classification: "structure"
                                                                        role: "namespace"
                                                                        description: "SCDL state transition entry action descriptor."
                                                                    }
                                                                }
                                                                {
                                                                    jsonTag: "exitAction"
                                                                    label: "Exit Action"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "parent"
                                                                        classification: "structure"
                                                                        role: "namespace"
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
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL type models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "type"
                                            label: "Type"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
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
                                type: "object"
                                origin: "parent"
                                classification: "structure"
                                role: "namespace"
                                description: "SCDL asset models by namespace."
                            }
                            subMenus: [
                                {
                                    jsonTag: "people"
                                    label: "People"
                                    objectDescriptor: {
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL person models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "person"
                                            label: "Person"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
                                                description: "SCDL person model."
                                            }
                                        } # Person
                                    ] # People submenus
                                } # People
                                {
                                    jsonTag: "organizations"
                                    label: "Organizations"
                                    objectDescriptor: {
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL organization models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "organization"
                                            label: "Organization"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
                                                description: "SCDL organization model."
                                            }
                                        }
                                    ] # Organizations submenus
                                } # Organizations
                                {
                                    jsonTag: "licenses"
                                    label: "Licenses"
                                    objectDescriptor: {
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL license models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "license"
                                            label: "License"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
                                                description: "SCDL license model."
                                            }
                                        } # Licesne
                                    ] # Licesnes submenus
                                } # Licenses
                                {
                                    jsonTag: "copyrights"
                                    label: "Copyrights"
                                    objectDescriptor: {
                                        type: "array"
                                        origin: "parent"
                                        classification: "structure"
                                        role: "extension"
                                        description: "SCDL copyright models."
                                    }
                                    subMenus: [
                                        {
                                            jsonTag: "copyright"
                                            label: "Copyright"
                                            objectDescriptor: {
                                                type: "object"
                                                origin: "user"
                                                classification: "mutable"
                                                role: "namespace"
                                                description: "SCDL copyright model."
                                            }
                                        } # Copyright
                                    ] # Copyrights submenus
                                } # Copyrights
                            ] # Assets submenu
                        } # Assets
                    ] # Catalogue submenu
                } # Catalogue
            ] # Schema submenus
        } # Schema

    ] # ScdlNavigatorWindowLayout
} # layout object    
    

