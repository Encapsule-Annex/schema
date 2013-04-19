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
                        description: "SCDL Catalogue"
                    }
                    subMenus: [
                        {
                            menu: "Specifications"
                            objectDescriptor: {
                                type: "array"
                                origin: "parent"
                                classification: "structure"
                                role: "extension"
                                description: "SCDL specification contained in this catalogue."
                            }
                            subMenus: [
                                {
                                    menu: "Specification"
                                    objectDescriptor: {
                                        type: "object"
                                        origin: "user"
                                        classification: "mutable"
                                        role: "namespace"
                                        description: "SCDL specification model."
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
                                description: "Models is a collection of SCDL model objects segretated by model type."
                            }
                            subMenus: [
                                {
                                    menu: "Systems"
                                    objectDescriptor: {
                                        type: "array"
                                        description: "Systems is an array of SCDL system model objects."
                                    }
                                    subMenus: [
                                        {
                                            menu: "System"
                                            subMenus: [
                                                {
                                                    menu: "Pins"
                                                    subMenus: [
                                                        {
                                                            menu: "Inputs"
                                                            subMenus: [
                                                                {
                                                                    menu: "Input"
                                                                } # Inputs submenus
                                                            ] # Inputs submenus
                                                        } # Inputs
                                                        {
                                                            menu: "Outputs"
                                                            subMenus: [
                                                                {
                                                                    menu: "Output"
                                                                } # Output
                                                            ] # Outputs submenus
                                                        } # Outputs
                                                    ] # Pins submenus
                                                } # Pins
                                                {
                                                    menu: "Models"
                                                    subMenus: [
                                                        {
                                                            menu: "Model"
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
                                        description: "Sockets is an array of SCDL socket model objects."
                                    }
                                    subMenus: [
                                        {
                                            menu: "Socket"
                                            subMenus: [
                                                {
                                                    menu: "Pins"
                                                    subMenus: [
                                                        {
                                                            menu: "Inputs"
                                                            subMenus: [
                                                                {
                                                                    menu: "Input"
                                                                } # Inputs submenus
                                                            ] # Inputs submenus
                                                        } # Inputs
                                                        {
                                                            menu: "Outputs"
                                                            subMenus: [
                                                                {
                                                                    menu: "Output"
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
                                        description: "Contracts is an array of SCDL socket contract model objects."
                                    }
                                    subMenus: [
                                        {
                                            menu: "Contract"
                                            subMenus: [
                                                {
                                                    menu: "Socket Identity"
                                                }
                                                {
                                                    menu: "Model Identity"
                                                }
                                                {   
                                                    menu: "Nodes"
                                                    subMenus: [
                                                        {
                                                            menu: "Node"
                                                            subMenus: [
                                                                {
                                                                    menu: "Source Pin"
                                                                }
                                                                {
                                                                    menu: "Sink Pins"
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
                                        description: "Machines is an array of SCDL machine model objects."
                                    }
                                    subMenus: [
                                        {
                                            menu: "Machine"
                                            subMenus: [
                                                {
                                                    menu: "Pins"
                                                    subMenus: [
                                                        {
                                                            menu: "Inputs"
                                                            subMenus: [
                                                                {
                                                                    menu: "Input"
                                                                } # Inputs submenus
                                                            ] # Inputs submenus
                                                        } # Inputs
                                                        {
                                                            menu: "Outputs"
                                                            subMenus: [
                                                                {
                                                                    menu: "Output"
                                                                } # Output
                                                            ] # Outputs submenus
                                                        } # Outputs
                                                    ] # Pins submenus
                                                } # Pins
                                                {
                                                    menu: "States"
                                                    subMenus: [
                                                        {
                                                            menu: "State"
                                                            subMenus: [
                                                                {
                                                                    menu: "Actions"
                                                                    subMenus: [
                                                                        {
                                                                            menu: "Entry"
                                                                        } # Entry
                                                                        {
                                                                            menu: "Exit"
                                                                        } # Exit
                                                                    ] # Actions submenus
                                                                } # Actions
                                                                {
                                                                    menu: "Transitions"
                                                                    subMenus: [
                                                                        {
                                                                            menu: "Transition"
                                                                        } # Transition
                                                                    ] # Transitions submenus
                                                                } # Transitions
                                                            ] # State submenus
                                                        } # State
                                                    ] # States submenus
                                                } # States
                                            ] # Machine submenus
                                        } # Machine
                                    ] # Machines submenus
                                } # Machines
                                {
                                    menu: "Types"
                                    objectDescriptor: {
                                        type: "array"
                                        description: "Types is an array of SCDL type model objects."
                                    }
                                    subMenus: [
                                        {
                                            menu: "Type"
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
    

