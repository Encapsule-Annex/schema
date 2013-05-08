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

    baseBackgroundColor: Color({ hue: 190, saturation: 1, value: 0.4}).toCSS()
    baseBackgroundRatioPercentPerLevel: 0

    borderLightRatio: 0.35
    borderDarkRatio: 0.35
    borderFlatRatio: -2
    borderWidth: 0 # default
    borderWidthOutset: 0
    borderWidthInset: 0
    borderWidthFlat: 3

    fontColorRatioDefault: 0.45
    fontColorRatioSelected: -0.8
    fontColorRatioSelectedChild: -0.8
    fontColorRatioMouseOver: -1
    
    selectedItemBackgroundShiftHue: 0
    selectedItemBackgroundLightenRatio: 0.5

    selectedChildItemBackgroundShiftHue: 0
    selectedChildItemBackgroundLightenRatio: 0.5

    mouseOverItemBackgroundShiftHue: -5
    mouseOverItemBackgroundLightenRatio: 0.5


    menuLevelPaddingTop: 1
    menuLevelPaddingBottom: 5
    menuLevelPaddingLeft: 5
    menuLevelPaddingRight: 5

    menuLevelFontSizeMax: 16
    menuLevelFontSizeMin: 12


    structureArrayShiftHue: 0
    structureArrayLightenRatio: 0.5

    metaArrayElementShiftHue: 0
    metaArrayElementLightenRatio: 0.2

    archetypeShiftHue: 0
    archetypeSaturateRatio: -0.8
    archetypeLightenRatio: 0.4
    
    elementShiftHue: -50
    elementSaturateRatio: 0.5
    elementLightenRatio: 0.6


    menuLevelBoxShadowColorDarkenRatio: 0.4 # Used as shadow color if mouse over or selection path
    menuLevelBoxShadowColorLightenRatio: 0.35

    menuLevelBoxShadowInSelectionPath: { type: "inset", xBase: 1, xPerLevel: 1, yBase: 1, yPerLevel: 1, blurBase: 5, blurPerLevel: 1 }
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


    # There are two separate namespace hierarchies defined here:
    #
    # The outer, or the navigator namespace, is comprised of a singly
    # rooted tree (the root is defined implicitly and auto-generated).
    # Each menu item in the navigator namespace is given an ID string.
    # The ID's of sibling menu items must be distinct to ensure that each
    # menu item is addressable withing the navigator namespace. Other than
    # this stipulation, menu ID's do not need to be unique as references to
    # a menu item are specified by its full navigator namespace path. (This
    # allows for re-use of menu item declarations).
    #
    # The inner namespace, or the hosted model view namespace, mirrors the
    # outer navigator namespace precisely in topology but has alternate semantics.
    # Most notably, the inner namespace objects inherit their ID's from a menu
    # item's objectDescriptor.jsonTag along with a number of other attributes that
    # specialize the behavior of the inner hosted model view object. There are no
    # restrictions placed on the uniqueness of the jsonTag's given hosted model
    # view namespace objects because they're always referenced indirectly via
    # the outer navigator namespace path. 
    #


    menuHierarchy: [
        {
            jsonTag: "schema"
            label: "schema.encapsule.org"
            objectDescriptor: {
                mvvmType: "child"
                description: "#{appName} App Root"
            }


            subMenus: [

                {
                    jsonTag: "catalogues"
                    label: "Catalogues"
                    objectDescriptor: {
                        jsonTag: "SCDLCatalogues"
                        mvvmType: "extension"
                        description: "Manage SCDL catalogues in your local repository."
                        archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutCatalogueArchetype
                    }
                }

                {
                    jsonTag: "sessions"
                    label: "Sessions"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "Manager current and past work sessions."
                        archetype: {
                            jsonTag: "session"
                            label: "Session"
                            objectDescriptor: {
                                mvvmType: "archetype"
                                description: "#{appName} session object."
                            } # session objectDescriptor
                        } # session archetype
                    } # sessions objectDescriptor
                } # sessions

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
                                description: "#{appName} customizations."
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
                                                archetype: {
                                                    jsonTag: "source"
                                                    label: "Source"
                                                    objectDescriptor: {
                                                        mvvmType: "archetype"
                                                        description: "Source descriptor for remote SCDL catalogue(s)."
                                                    }
                                                } # remote
                                            } # remote archetype
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
    

