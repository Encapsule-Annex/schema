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



Encapsule.code.app.modelview.ScdlNavigatorWindowLayout = {

    title: "SCDL Catalogue"

    baseBackgroundColor: "#00CCFF"
    baseBackgroundRatioPercentPerLevel: 0.0 

    borderLightRatio: 0.2
    borderDarkRatio: 0.5
    borderFlatRatio: -2
    borderWidth: 1 # default
    borderWidthOutset: 1
    borderWidthInset: 1
    borderWidthFlat: 2

    fontColorRatioDefault: 5
    fontColorRatioSelected: -2
    fontColorRatioSelectedChild: -2
    fontColorRatioMouseOver: 5
    
    selectedItemBackgroundShiftHue: 0
    selectedItemBackgroundLightenRatio: 0.3

    selectedChildItemBackgroundShiftHue: 0
    selectedChildItemBackgroundLightenRatio: 0

    mouseOverItemBackgroundShiftHue: -10
    mouseOverItemBackgroundLightenRatio: 0.3


    menuLevelPaddingTop: 1
    menuLevelPaddingBottom: 6
    menuLevelPaddingLeft: 4
    menuLevelPaddingRight: 4

    menuLevelFontSizeMax: 12
    menuLevelFontSizeMin: 12

    structureArrayShiftHue: 0
    structureArrayLightenRatio: -0.2

    userObjectShiftHue: 310
    userObjectDarkenRatio: 0.3




    menuHierarchy: [
        {
                    jsonTag: "scdlCatalogue"
                    menu: "Catalogue"
                    objectDescriptor: {
                        type: "object"
                        origin: "new"
                        classification: "structure"
                        role: "namespace"
                        description: "SCDL catalogue."
                    }
                    subMenus: [
                        {
                            jsonTag: "specifications"
                            menu: "Specifications"
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
                                    menu: "Specification"
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
                                            menu: "System Instances"
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
                                                    menu: "System Instance"
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
                                                            menu: "Socket Instances"
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
                                                                    menu: "Socket Instance"
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
                                                                            menu: "Instance Bindings"
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
                                                                                    menu: "Instance Binding"
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
                            menu: "Models"
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
                                    menu: "Systems"
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
                                            menu: "System"
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
                                                    menu: "I/O Pins"
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
                                                            menu: "Input Pins"
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
                                                                    menu: "Input Pin"
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
                                                            menu: "Output Pins"
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
                                                                    menu: "Output Pin"
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
                                                    menu: "Models"
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
                                                            menu: "Model"
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
                                                    menu: "Nodes"
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
                                                            menu: "Node"
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
                                    menu: "Sockets"
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
                                            menu: "Socket"
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
                                                    menu: "I/O Pins"
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
                                                            menu: "Input Pins"
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
                                                                    menu: "Input Pin"
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
                                                            menu: "Output Pins"
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
                                                                    menu: "Output Pin"
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
                                    menu: "Contracts"
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
                                            menu: "Contract"
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
                                                    menu: "Socket Reference"
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
                                                    menu: "Model Reference"
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
                                                    menu: "Nodes"
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
                                                            menu: "Node"
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
                                                                    menu: "Source Pin"
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
                                                                    menu: "Sink Pins"
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
                                                                            menu: "Sink Pin"
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
                                    menu: "Machines"
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
                                            menu: "Machine"
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
                                                    menu: "I/O Pins"
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
                                                            menu: "Input Pins"
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
                                                                    menu: "Input Pin"
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
                                                            menu: "Output Pins"
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
                                                                    menu: "Output Pin"
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
                                                    menu: "States"
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
                                                            menu: "State"
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
                                                    menu: "Transitions"
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
                                                            menu: "Transition"
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
                                                    menu: "Actions"
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
                                                            menu: "Action"
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
                                                                    menu: "Entry Action"
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
                                                                    menu: "Exit Action"
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
                                    menu: "Types"
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
                                            menu: "Type"
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
                            menu: "Assets"
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
                                    menu: "People"
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
                                            menu: "Person"
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
                                    menu: "Organizations"
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
                                            menu: "Organization"
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
                                    menu: "Licenses"
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
                                            menu: "License"
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
                                    menu: "Copyrights"
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
                                            menu: "Copyright"
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

    ] # ScdlNavigatorWindowLayout
} # layout object    
    

