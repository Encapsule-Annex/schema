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
    title: "SCDL Navigator"
    baseBackgroundColor: "#0099FF"
    baseBackgroundRatioPercentPerLevel: 0.05
    
    currentlySelectedBackgroundColor: "white"
    currentlySelectedProximityBackgroundColor: "#0099FF"

    currentlySelectedParentProximityBackgroundColor: "#00CCFF"

    mouseOverHighlightBackgroundColor: "#00FF00"
    mouseOverSelectedBackgroundColor: "#00FF00"
    mouseOverHighlightProximityBackgroundColor: "#00CCFF"

    menuLevelPaddingTop: 0
    menuLevelPaddingBottom: 5
    menuLevelPaddingLeft: 2
    menuLevelPaddingRight: 0

    menuLevelMargin: "2px"
    menuHierarchy: [
        {
            menu: "Catalogues"
            subMenus: [
                {
                    menu: "Catalogue"
                    subMenus: [
                        {
                            menu: "Specifications"
                            subMenus: [
                                {
                                    menu: "Specification"
                                    subMenus: [
                                        {
                                            menu: "Systems"
                                            subMenus: [
                                                {
                                                    menu: "System"
                                                    subMenus: [
                                                        {
                                                            menu: "Sockets"
                                                            subMenus: [
                                                                {
                                                                    menu: "Socket"
                                                                    subMenus: [
                                                                        {
                                                                            menu: "Bindings"
                                                                            subMenus: [
                                                                                {
                                                                                    menu: "Binding"
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
                            subMenus: [
                                {
                                    menu: "Systems"
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
                            subMenus: [
                                {
                                    menu: "People"
                                    subMenus: [
                                        {
                                            menu: "Person"
                                        } # Person
                                    ] # People submenus
                                } # People
                                {
                                    menu: "Organizations"
                                    subMenus: [
                                        {
                                            menu: "Organization"
                                        }
                                    ] # Organizations submenus
                                } # Organizations
                                {
                                    menu: "Licenses"
                                    subMenus: [
                                        {
                                            menu: "License"
                                        } # Licesne
                                    ] # Licesnes submenus
                                } # Licenses
                                {
                                    menu: "Copyrights"
                                    subMenus: [
                                        {
                                            menu: "Copyright"
                                        } # Copyright
                                    ] # Copyrights submenus
                                } # Copyrights
                            ] # Assets submenu
                        } # Assets
                    ] # Catalogue submenu
                } # Catalogue
            ] # Catalogues submenu
        } # Catalogues
    ] # ScdlNavigatorWindowLayout
} # layout object    
    

