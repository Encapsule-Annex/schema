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
# encapsule-lib-omm-object-model.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.implementation = Encapsule.code.lib.omm.implementation? and Encapsule.code.lib.omm.implementation or @Encapsule.code.lib.omm.implementation = {}



#
# ****************************************************************************
Encapsule.code.lib.omm.implementation.RootObjectDescriptorFactory = (jsonTag_, label_, description_, menuHierarchy_) ->
    try
        rootObjectDescriptor = {
            jsonTag: jsonTag_
            label: label_
            objectDescriptor: {
                mvvmType: "root"
                description: description_
                namespaceDescriptor: {
                    userImmutable: {
                        userAgent: {
                            type: "object"
                            fnCreate: -> {
                                appPublisher: appPackagePublisher
                                appName: appName
                                appVersion: appVersion
                                appId: appId
                                appReleaseId: appReleaseId
                                appBuildId: appBuildId
                                appBuildTime: appBuildTime
                            }
                            fnReinitialize: undefined
                        } # userAgent
                    } # userImmutable
                } # namespaceDescriptor
            } #object Descriptor
            subMenus: menuHierarchy_
        } # rootObjectDescriptor

        return rootObjectDescriptor

    catch exception
        throw "Encapsule.code.lib.omm.implementation.RooObjectDescriptorFactor function failed: #{exception}"
# ****************************************************************************
#

#
#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectModelBase
    constructor: (objectModelDeclaration_) ->
        try

            # --------------------------------------------------------------------------
            buildOMDescriptorFromLayout = (objectModelLayoutObject_, path_, parentDescriptor_, componentDescriptor_, parentPathIdVector_, parentPathExtensionPointIdVector_) =>
                try
                    if not (objectModelLayoutObject_? and objectModelLayoutObject_) then throw "Missing object model layout object input parameter!"

                    # Local variables used to construct this descriptor.
                    tag = objectModelLayoutObject_.jsonTag

                    path = path_? and path_ and "#{path_}.#{tag}" or tag

                    id = @countDescriptors
                    @countDescriptors++ # set up for the next invocation of this function (use the id var locally)

                    parentPathExtensionPoints = undefined
                    if parentPathExtensionPointIdVector_? and parentPathExtensionPointIdVector_
                        parentPathExtensionPoints = Encapsule.code.lib.js.clone parentPathExtensionPointIdVector_
                    else
                        parentPathExtensionPoints = []

                    mvvmType = objectModelLayoutObject_.objectDescriptor.mvvmType
                    extensionDescriptor = objectModelLayoutObject_.objectDescriptor.archetype # may be undefined
                    extensionPathId = -1

                    # Build this descriptor and add it to the OM's descriptor array.
                    thisDescriptor = @objectModelDescriptorById[id] = {
                        "id": id
                        "idComponent": id
                        "isComponent": false
                        "componentNamespaceIds": []
                        "jsonTag": tag
                        "path":  path
                        "label": objectModelLayoutObject_.label
                        "description": objectModelLayoutObject_.objectDescriptor.description
                        "namespaceDescriptor": objectModelLayoutObject_.objectDescriptor.namespaceDescriptor
                        "mvvmType": mvvmType
                        "archetypePathId": -1           
                        "parent": parentDescriptor_
                        "parentPathIdVector": []
                        "parentPathExtensionPoints": parentPathExtensionPoints
                        "children": []
                         }

                    # Add this descriptor to the OM intance's path map for fast look-up based on path.
                    @objectModelPathMap[path] = thisDescriptor

                    # Add this descriptor to parent descriptor's children array
                    if parentDescriptor_? and parentDescriptor_
                        parentDescriptor_.children.push thisDescriptor
                        # Clone the parent's parentPathIdVector and add ourselves to it.
                        thisDescriptor.parentPathIdVector = Encapsule.code.lib.js.clone parentDescriptor_.parentPathIdVector
                        thisDescriptor.parentPathIdVector.push parentDescriptor_.id

                    if @rankMax < thisDescriptor.parentPathIdVector.length
                        @rankMax = thisDescriptor.parentPathIdVector.length

                    componentDescriptor = undefined
                    switch mvvmType
                        when "extension"
                            if not (componentDescriptor_? and componentDescriptor_) then throw "Internal error: componentDescriptor_ should be defined."
                            thisDescriptor.idComponent = thisDescriptor.parent.idComponent
                            componentDescriptor = componentDescriptor_
                            componentDescriptor.extensionPoints[path] = thisDescriptor
                            if not (extensionDescriptor? and extensionDescriptor)
                                throw "Cannot resolve extension object descriptor."
                            updatedParentPathExtensionPointIdVector = Encapsule.code.lib.js.clone parentPathExtensionPoints
                            updatedParentPathExtensionPointIdVector.push id
                            @countExtensionPoints++
                            # *** RECURSION
                            buildOMDescriptorFromLayout(extensionDescriptor, path, thisDescriptor, componentDescriptor, thisDescriptor.parentPathIdVector, updatedParentPathExtensionPointIdVector)
                            break

                        when "archetype"
                            thisDescriptor.isComponent = true
                            thisDescriptor.extensionPoints = {}
                            parentDescriptor_.archetypePathId = id
                            componentDescriptor = thisDescriptor
                            @countExtensions++
                            @countComponents++
                            break

                        when "root"
                            if componentDescriptor_? or componentDescriptor then throw "Internal error: componentDescriptor_ should be undefined."
                            thisDescriptor.isComponent = true
                            thisDescriptor.extensionPoints = {}
                            componentDescriptor = thisDescriptor
                            @countComponents++
                            break

                        when "child"
                            thisDescriptor.idComponent = thisDescriptor.parent.idComponent
                            componentDescriptor = componentDescriptor_
                            @countChildren++
                            break
                        else
                            throw "Unrecognized MVVM type \"#{mvvmType}\" in call."

                    @objectModelDescriptorById[thisDescriptor.idComponent].componentNamespaceIds.push thisDescriptor.id

                    if not (objectModelLayoutObject_.subMenus? and objectModelLayoutObject_.subMenus)
                        return true

                    for subObjectDescriptor in objectModelLayoutObject_.subMenus
                        # *** RECURSION
                        buildOMDescriptorFromLayout(subObjectDescriptor, path, thisDescriptor, componentDescriptor, thisDescriptor.parentPathIdVector, parentPathExtensionPoints)

                    return true

                catch exception
                    throw "buildOMDescriptorFromLayout fail: #{exception}"

            # / END: buildOMDesriptorFromLayout

            # --------------------------------------------------------------------------
            Console.message("Encapsule.code.lib.omm.ObjectModel: Processing object model declaration '#{objectModelDeclaration_.jsonTag}'")

            if not (objectModelDeclaration_? and objectModelDeclaration_)
                throw "Missing object model delcaration input parameter!"

            @jsonTag = objectModelDeclaration_.jsonTag
            @label = objectModelDeclaration_.label
            @description = objectModelDeclaration_.description
            
            # Create the root object descriptor (note that this is a generic descriptor shared by all
            # instances of ObjectModel. The namespace is reserved for use by OMM itself and cannot be
            # accessed via the object model layout declaration object.

            rootObjectDescriptor = Encapsule.code.lib.omm.implementation.RootObjectDescriptorFactory(
                @jsonTag
                @label
                @description
                objectModelDeclaration_.menuHierarchy
                )

            # ObjectModel instances take a deep copy of objectModelDeclaration_
            @objectModelDeclaration = Encapsule.code.lib.js.clone objectModelDeclaration_

            if not (@objectModelDeclaration? and @objectModelDeclaration)
                throw "Failed to clone source object model declaration."

            # Note that we patch our _copy_ of the declaration leaving the original declaration unchanged.
            @objectModelDeclaration.menuHierarchy = [ rootObjectDescriptor ]

            #
            # objectModelDescriptor = (required) reference to OM layout declaration object
            # path = (optional/used in recursion) parent descriptor's OM path (defaults to jsonTag if undefined)
            # rank = (optional/used in recursion) directed graph rank (aka level - a zero-based count of tree depth)
            # parentDescriptor_ = (optional/used in recursion) 
            #
            # buildOMDescriptorFromLayout additionally depends on the following class members
            #

            @objectModelPathMap = {}
            @objectModelDescriptorById = []

            @countDescriptors = 0
            @countComponents = 0
            @countExtensionPoints = 0
            @countExtensions = 0
            @countChildren = 0
            @rankMax = 0

            # *** START RECURSION
            buildOMDescriptorFromLayout(rootObjectDescriptor)

            # Some basic consistency checks to ensure that completely screwed up declaratons
            # aren't foisted upon unsuspecting observers.

            if @countExtensionPoints != @countExtensions
                throw "Layout declaration error: extension point and extension descriptor counts do not match. countExtensionPoints=#{@countExtensionPoints} countExtensions=#{@countExtensions}"

            if @countComponents != @countExtensionPoints + 1
                throw "Layout declaration error: component count should be extension count + 1. componentCount=#{@componentCount} countExtensions=#{@countExtensions}"

            # Debug summary output.
            Console.message("... '#{@jsonTag}' root descriptor")
            Console.message("... #{@countChildren} child descriptor(s)")
            Console.message("... #{@countExtensionPoints} extension point descriptor(s)")
            Console.message("... #{@countExtensions} extension descriptor(s)")
            Console.message("... <strong>#{@countDescriptors} total namespace declarations processed.</strong>")
            Console.message("... ... #{@countComponents} composable components / tallest leaf = rank #{@rankMax}")


        catch exception
            throw "Encapsule.code.lib.omm.ObjectModelBase.construction failure: #{exception}"

# ****************************************************************************
#


#
#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectModel extends Encapsule.code.lib.omm.ObjectModelBase
    constructor: (objectModelDeclaration_) ->
        try
            super(objectModelDeclaration_)


            # --------------------------------------------------------------------------
            @getPathIdFromPath = (objectModelPath_) =>
                try
                    if not (objectModelPath_? and objectModelPath_) then throw "Missing object model path parameter!"

                    objectModelDescriptor = @objectModelPathMap[objectModelPath_]
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Unable to resolve object model descriptor!"
        
                    objectModelPathId = objectModelDescriptor.id
                    if not objectModelPathId?
                        throw "Internal error: Unable to resolve object model path ID from object model descriptor."

                    return objectModelPathId

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModel.getPathIdFromPath fail: #{exception}"


            # --------------------------------------------------------------------------
            @getPathFromPathId = (pathId_) =>
                try
                    if not (pathId_?) then throw "Missing path ID parameter!"

                    objectModelDescriptor = @objectModelDescriptorById[pathId_]
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Unable to resolve object descriptor for path ID #{pathId_}"
                    path = objectModelDescriptor.path
                    return path

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModel.getPathFromPathId fail: #{exception}"


            # --------------------------------------------------------------------------
            @createNamespaceSelectorFromPathId = (pathId_, selectKeyVector_) =>
                try
                    selector = new Encapsule.code.lib.omm.ObjectModelNamespaceSelector(@, pathId_, selectKeyVector_)
                    return selector
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModel.createNamespaceSelectorFromPathId failed: #{exception}"

            # --------------------------------------------------------------------------
            @createNamespaceSelectorFromPath = (path_, selectKeyVector_) =>
                try
                    pathId = @getPathIdFromPath(path_)
                    selector = @createNamespaceSelectorFromPathId(pathId, selectKeyVector_)
                    return selector
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModel.createNamespaceSelectorFromPath failed: #{exception}"

            # --------------------------------------------------------------------------
            @getSemanticBindings = =>
                try
                    semanticBindings = @objectModelDeclaration.semanticBindings
                    if not (semanticBindings? and semanticBindings) then throw "Object model declaration does not include required semanticBindings namespace."
                    return semanticBindings
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModel failure: #{exception}"


            # CONSTRUCT THE ROOT OBJECT DESCRIPTOR FROM THE SPECIFIED OBJECT MODEL LAYOUT 
            # **************************************************************************

        catch exception
            throw "Encapsule.code.lib.omm.ObjectModel construction fail: #{exception}"
# ****************************************************************************
#