###

  http://schema.encapsule.org/

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# schema-scdl-navigator-layout-catalogue.coffee

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}


Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutCatalogueArchetype = {

    jsonTag: "scdlCatalogueArchetype"
    label: "Catalogue"
    objectDescriptor: {
        mvvmType: "archetype"
        mvvmJsonTag: "scdlCatalogue"
        description: "SCDL catalogue object archetype."
    }
    subMenus: [
        {
            jsonTag: "specifications"
            label: "Specifications"
            objectDescriptor: {
                mvvmType: "extension"
                description: "SCDL specification."
                archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSpecificationArchetype 
            } # specification objectDescriptor
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
                        archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSystemArchetype
                    } # systems objectDescriptor
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
    ] # Catalogue submenus
} # Catalogue archetype

