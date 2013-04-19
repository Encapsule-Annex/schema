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
    baseBackgroundColor: "#0099CC"
    baseBackgroundRatioPercentPerLevel: 0.05
    
    currentlySelectedBackgroundColor: "#00FFFF"
    currentlySelectedProximityBackgroundColor: "#00CCFF"
    currentlySelectedProximityRatioPerecentPerLevel: 0.06

    currentlySelectedParentProximityBackgroundColor: "#00DDFF"

    mouseOverHighlightBackgroundColor: "white"
    mouseOverSelectedBackgroundColor: "white"
    mouseOverHighlightProximityBackgroundColor: "#00E0FF"
    mouseOverHighlightProximityRatioPercentPerLevel: 0.05

    menuLevelPaddingTop: 0
    menuLevelPaddingBottom: 7
    menuLevelPaddingLeft: 4
    menuLevelPaddingRight: 4

    menuLevelFontSizeMax: 14
    menuLevelFontSizeMin: 12



    menuLevelMargin: "2px"
    menuHierarchy: [
        {
                    menu: "Catalogue"
                    objectDescriptor: {
                        type: "object"
                        origin: "external"
                        classification: "structure"
                        role: "namespace"
                        description: "SCDL catalogue."
                    }
                    subMenus: [
                        {
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
                                            menu: "Systems"
                                            objectDescriptor: {
                                                type: "array"
                                                origin: "parent"
                                                classification: "structure"
                                                role: "extension"
                                                description: "SCDL system model instances."
                                            }
                                            subMenus: [
                                                {
                                                    menu: "System"
                                                    objectDescriptor: {
                                                        type: "object"
                                                        origin: "user"
                                                        classification: "mutable"
                                                        role: "namespace"
                                                        description: "SCDL system model instance."
                                                    }
                                                    subMenus: [
                                                        {
                                                            menu: "Sockets"
                                                            objectDescriptor: {
                                                                type: "array"
                                                                origin: "parent"
                                                                classification: "structure"
                                                                role: "extension"
                                                                description: "SCDL socket model instances."
                                                            }
                                                            subMenus: [
                                                                {
                                                                    menu: "Socket"
                                                                    objectDescriptor: {
                                                                        type: "object"
                                                                        origin: "user"
                                                                        classification: "mutable"
                                                                        role: "namespace"
                                                                        description: "SCDL socket model instance." 
                                                                    }
                                                                    subMenus: [
                                                                        {
                                                                            menu: "Bindings"
                                                                            objectDescriptor: {
                                                                                type: "array"
                                                                                origin: "parent"
                                                                                classification: "structure"
                                                                                role: "extension"
                                                                                description: "SCDL socket model instance bindings."
                                                                            }
                                                                            subMenus: [
                                                                                {
                                                                                    menu: "Binding"
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
                                                    menu: "I/O Pins"
                                                    objectDescriptor: {
                                                        type: "array"
                                                        origin: "parent"
                                                        classification: "structure"
                                                        role: "extension"
                                                        description: "SCDL pin models by function."
                                                    }
                                                    subMenus: [
                                                        {
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
                                                    menu: "Nodes"
                                                    subMenus: [
                                                        {
                                                            menu: "Node"
                                                        } # Node
                                                    ] # Nodes submenus
                                                } # Nodes
                                            ] # System submenus
                                        } # Systems submenus
                                    ] # Systems submenus
                                } # Systems
                                {
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
    

