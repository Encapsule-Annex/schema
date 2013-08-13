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


    jsonTag: "schema"
    label: "#{appName}"
    description: "#{appName} client root."

    initialSelectionPath: "schema"

    ###
    For now all these style declarations used by the v1 navigator library are disabled
    as the new v2 OMM's MVVM classes leverage CSS exclusively.

    detailBelowSelectDefault: 1
    detailAboveSelectDefault: 1

    baseBackgroundColor: Color({ hue: 190, saturation: 1, value: 0.5}).toCSS()
    baseBackgroundRatioPercentPerLevel: 0

    borderLightRatio: 0.35
    borderDarkRatio: 0.45
    borderFlatRatio: -2
    borderWidth: 1 # default
    borderWidthOutset: 1
    borderWidthInset: 1
    borderWidthFlat: 2

    fontColorRatioDefault: 0.45
    fontColorRatioSelected: -2 # -0.8
    fontColorRatioSelectedChild: -2 # -0.8
    fontColorRatioMouseOver: -1
    
    selectedItemBackgroundShiftHue: 20
    selectedItemBackgroundLightenRatio: 0.5

    # with respect to a specific menu level, this style applies if the level has a child selected.
    selectedChildItemBackgroundShiftHue: 20
    selectedChildItemBackgroundLightenRatio: 0.5

    mouseOverItemBackgroundShiftHue: 0
    mouseOverItemBackgroundLightenRatio: 0.4

    menuLevelPaddingTop: 1
    menuLevelPaddingBottom: 5
    menuLevelPaddingLeft: 5
    menuLevelPaddingRight: 5

    menuLevelFontSizeMax: 12
    menuLevelFontSizeMin: 12

    structureArrayShiftHue: 0
    structureArrayLightenRatio: -0.15

    metaArrayElementShiftHue: -30
    metaArrayElementLightenRatio: 0.2

    archetypeShiftHue: 0
    archetypeSaturateRatio: -0.5
    archetypeLightenRatio: 0.2
    
    elementShiftHue: -10
    elementSaturateRatio: 0.3
    elementLightenRatio: 0.1


    menuLevelBoxShadowColorDarkenRatio: 0.1 # Used as shadow color if mouse over or selection path
    menuLevelBoxShadowColorLightenRatio: 0.6

    menuLevelBoxShadowInSelectionPath: { type: "inset", xBase: 1, xPerLevel: 0, yBase: 1, yPerLevel: 0, blurBase: 10, blurPerLevel: 0 }
    menuLevelBoxShadowNotSelected: { type: "inset", x: 0, y: 16, blur: 16 }

    menuLevelBoxShadowMouseOverHighlight: { type: "inset", x: 1,  y: 1, blur:  3 }

    menuLevelBoxShadowMouseOverSelected: { type: "inset", x: 0, y: 0, blur: 0 } 


    # Left over from v1 navigator library. Kept for reference. We're not going to couple object model
    # declaration with any sort of routing behavior (local or otherwise). The concepts are orthogonal
    # generally as in non-trivial apps it's possible that several different OMM instances are active
    # and the notion of addressable state is thus a higher-level concept than any specific OMM instance
    # is able to manage.

    externalIntegration: {
        fnNotifyPathChange: (navigatorContainer_, path_) ->
            # We currently instantiate the SchemaRouter after the navigator. The first selection change
            # will not be forwarded. That's okay.
            if Encapsule.runtime.app.SchemaRouter? and Encapsule.runtime.app.SchemaRouter
                Encapsule.runtime.app.SchemaRouter.setRoute(path_)
    }

    ###


    semanticBindings: {
        update: (namespaceObjectReference_) ->
            if namespaceObjectReference_.revision?
                namespaceObjectReference_.revision++
            if namespaceObjectReference_.updateTime?
                namespaceObjectReference_.updateTime = Encapsule.code.lib.util.getEpochTime()
            if namespaceObjectReference_.uuidRevision?
                namespaceObjectReference_.uuidRevision = uuid.v4()
            return true

        getLabel: (namespaceObjectReference_) ->
            label = namespaceObjectReference_["name"]? and namespaceObjectReference_["name"] or
                namespaceObjectReference_["uuid"]? and namespaceObjectReference_["uuid"] or
                undefined
            return label

        getUniqueKey: (namespaceObjectReference_) ->
            key = namespaceObjectReference_["uuid"]? and namespaceObjectReference_["uuid"] or undefined
            return key
    }


    # TODO: Update these comments for OMM lib.
    #
    # There are two separate namespace hierarchies defined here:
    #
    # The outer, or the navigator namespace, is comprised of a singly
    # rooted tree (the root is defined implicitly and auto-generated).
    # Each menu item in the navigator namespace is given an ID string.
    # The ID's of sibling menu items must be unique to ensure that each
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
    
        # Encapsule.code.app.modelview.OMMDeclarationTest

        {
            jsonTag: "client"
            label: "Client"
            objectDescriptor: {
                mvvmType: "child"
                description: "#{appName} client home."
                namespaceDescriptor: {
                    userImmutable: {
                        clientDeployment: {
                            type: "uuid"
                            fnCreate: -> uuid.v4()
                            fnReinitialize: undefined
                        } # clientDeployment
                        localSession: {
                            type: "object"
                            fnCreate: -> {
                                uuid: uuid.v4()
                                timeStart: Encapsule.code.lib.util.getEpochTime()
                            }
                            fnReinitialize: undefined
                        } # localSession
                    } # userImmutable
                } # namespaceDescriptor
            } # objectDescriptor
    
            subMenus: [

                # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutTools


                {
                    jsonTag: "catalogues"
                    label: "Catalogues"
                    objectDescriptor: {
                        jsonTag: "catalogues"
                        mvvmType: "extension"
                        description: "SCDL catalogue object collection."
                        archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutCatalogueArchetype
                        namespaceDescriptor: {
                        }
                    }
                }

                # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSettings


                {
                    jsonTag: "help"
                    label: "Help"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "#{appName} help."
                    }
                }

                {
                    jsonTag: "about"
                    label: "About"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "About namespace."
                    }
                } # about



            ] # Schema submenus
        } # Schema

    ] # ScdlNavigatorWindowLayout
} # layout object    
    

