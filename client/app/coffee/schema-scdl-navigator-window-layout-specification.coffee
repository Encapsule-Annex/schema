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
# schema-scdl-navigator-window-layout-specification.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}


Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSpecificationArchetype = {
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



} # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSpecificationArchetype
