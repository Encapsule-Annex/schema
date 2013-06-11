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
# encapsule-lib-omm-core.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.core = Encapsule.code.lib.omm.core? and Encapsule.code.lib.omm.core or @Encapsule.code.lib.omm.core = {}



#
# ****************************************************************************
Encapsule.code.lib.omm.RootObjectDescriptorFactory = (jsonTag_, label_, description_, menuHierarchy_) ->
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
        throw "Encapsule.code.lib.omm.RooObjectDescriptorFactor function failed: #{exception}"

# ****************************************************************************
#



#
#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectModel
    constructor: (objectModelDeclaration_) ->
        try
            Console.message("Encapsule.code.lib.omm.ObjectModel for #{objectModelDeclaration_.jsonTag}")

            if not (objectModelDeclaration_? and objectModelDeclaration_)
                throw "Missing object model delcaration input parameter!"

            @jsonTag = objectModelDeclaration_.jsonTag
            @label = objectModelDeclaration_.label
            @description = objectModelDeclaration_.description
            
            # --------------------------------------------------------------------------
            rootObjectDescriptor = Encapsule.code.lib.omm.RootObjectDescriptorFactory(
                @jsonTag
                @label
                @description
                objectModelDeclaration_.menuHierarchy
                )

            @objectModelDeclaration = Encapsule.code.lib.js.clone objectModelDeclaration_
            if not (@objectModelDeclaration? and @objectModelDeclaration)
                throw "Failed to clone source object model declaration."
            @objectModelDeclaration.menuHierarchy = [ rootObjectDescriptor ]


            #
            # --------------------------------------------------------------------------
            # objectModelDescriptor = reference to OM layout declaration object
            # path (optional) = parent descriptor's OM path (defaults to jsonTag if undefined)
            # rank (optional) = directed graph rank (aka level - a zero-based count of tree depth)
            # parent

            buildOMDescriptorFromLayout = (objectModelLayoutObject_, path_, rank_, parentDescriptor_, componentDescriptor_, inheritedExtensionPoints_) =>
                try
                    if not (objectModelLayoutObject_? and objectModelLayoutObject_) then throw "Missing object model layout object input parameter!"

                    # Local variables used to construct this descriptor.
                    tag = objectModelLayoutObject_.jsonTag

                    path = path_? and path_ and "#{path_}.#{tag}" or tag
                    rank = undefined
                    if rank_?
                        rank = rank_ + 1
                    else
                        rank = 0
                    if @rankMax < rank
                        @rankMax = rank

                    id = @countDescriptors
                    @countDescriptors++ # set up for the next invocation of this function (use the id var locally)

                    pathResolveExtensionPoints = undefined
                    if inheritedExtensionPoints_? and inheritedExtensionPoints_
                        pathResolveExtensionPoints = Encapsule.code.lib.js.clone inheritedExtensionPoints_
                    else
                        pathResolveExtensionPoints = []

                    mvvmType = objectModelLayoutObject_.objectDescriptor.mvvmType
                    extensionDescriptor = objectModelLayoutObject_.objectDescriptor.archetype

                    # Build this descriptor and add it to the OM's descriptor array.
                    thisDescriptor = @objectModelDescriptorById[id] = {
                        "id": id
                        "rank": rank
                        "jsonTag": tag
                        "path":  path
                        "pathResolveExtensionPoints": pathResolveExtensionPoints
                        "parent": parentDescriptor_
                        "children": []
                        "weight": 0
                         }

                    # Add this descriptor to parent descriptor's children array
                    if parentDescriptor_? and parentDescriptor_
                        parentDescriptor_.children.push thisDescriptor

                    # Add this descriptor to the OM intance's path map.
                    @objectModelPathMap[path] = thisDescriptor

                    componentDescriptor = undefined
                    switch mvvmType
                        when "extension"
                            if not (componentDescriptor_? and componentDescriptor_) then throw "Internal error: componentDescriptor_ should be defined."
                            componentDescriptor = componentDescriptor_
                            componentDescriptor.extensionPoints[path] = thisDescriptor
                            if not (extensionDescriptor? and extensionDescriptor)
                                throw "Cannot resolve extension object descriptor."
                            # Add this descriptor to OM instance's extension point map.
                            @objectModelExtensionPointMap[path] = thisDescriptor
                            updatedResolves = Encapsule.code.lib.js.clone pathResolveExtensionPoints
                            updatedResolves.push id

                            # RECURSION
                            buildOMDescriptorFromLayout(extensionDescriptor, path, rank, thisDescriptor, componentDescriptor, updatedResolves)
                            break

                        when "archetype"
                            thisDescriptor.isComponent = true
                            thisDescriptor.extensionPoints = {}
                            componentDescriptor = thisDescriptor
                            @objectModelExtensionMap[path] = thisDescriptor
                            @objectModelComponentMap[path] = thisDescriptor
                            break
                        when "root"
                            if componentDescriptor_? or componentDescriptor then throw "Internal error: componentDescriptor_ should be undefined."
                            thisDescriptor.isComponent = true
                            thisDescriptor.extensionPoints = {}
                            componentDescriptor = thisDescriptor
                            @objectModelComponentMap[path] = thisDescriptor
                            break
                        when "child"
                            componentDescriptor = componentDescriptor_
                            break
                        else
                            throw "Unrecognized MVVM type \"#{mvvmType}\" in call."

                    if not (objectModelLayoutObject_.subMenus? and objectModelLayoutObject_.subMenus)
                        return true

                    for subObjectDescriptor in objectModelLayoutObject_.subMenus
                        # RECURSION
                        buildOMDescriptorFromLayout(subObjectDescriptor, path, rank, thisDescriptor, componentDescriptor, pathResolveExtensionPoints)

                    return true

                catch exception
                    throw "buildOMDescriptorFromLayout fail: #{exception}"

            # / END: buildOMDesriptorFromLayout
            # --------------------------------------------------------------------------

            @objectModelComponentMap = {}
            @objectModelPathMap = {}
            @objectModelDescriptorById = []
            @objectModelExtensionPointMap = {}
            @objectModelExtensionMap = {}
            @countDescriptors = 0
            @rankMax = 0
            buildOMDescriptorFromLayout(rootObjectDescriptor)

            @countComponents = @objectModelComponentMap.length

            @countExtensionPoints = 0
            for memberName, functions of @objectModelExtensionPointMap
                @countExtensionPoints++

            @countExtensions = 0
            for memberName, functions of @objectModelExtensionMap
                @countExtensions++

            @countComponents = 0
            for memberName, functions of @objectModelComponentMap
                @countComponents++

            @countChildren = @countDescriptors - @countComponents

            if @countExtensionPoints != @countExtensions
                throw "Layout declaration error: extension point and extension descriptor counts do not match. countExtensionPoints=#{@countExtensionPoints} countExtensions=#{@countExtensions}"

            if @countComponents != @countExtensionPoints + 1
                throw "Layout declaration error: component count should be extension count + 1. componentCount=#{@componentCount} countExtensions=#{@countExtensions}"

            Console.message("ObjectModel for #{@jsonTag}:")
            Console.message("... #{@jsonTag} object comprises #{@countDescriptors} descriptors as follows:")
            Console.message("... ... 1 root descriptor")
            Console.message("... ... #{@countChildren} child descriptor(s)")
            Console.message("... ... #{@countExtensionPoints} extension point descriptor(s)")
            Console.message("... ... #{@countExtensions} extension descriptor(s)")
            Console.message("... The #{@jsonTag} object schema is partitioned into #{@countComponents} component(s).")
            Console.message("... The #{@jsonTag} object schema's tallest branch is #{@rankMax + 1} level(s) high.")


        catch exception
            throw "Encapsule.code.lib.omm.ObjectModel construction fail: #{exception}"

# ****************************************************************************
#



#
# An OM selector represents a unique object namespace within the space defined
# by the object model parameter.
# objectModel_ = reference to an instance of ObjectModel class
# objectModelPath_ = OM path
#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectModelSelector
    constructor: (objectModel_, pathId_, objectModelSelectVector_) ->
        try
            if not (objectModel_? and objectModel_) then throw "Missing object model input parameter."
            if not (pathId_?) then throw "Missing object model path parameter."

            if (pathId_ < 0) or (pathId_ >= objectModel_.objectModelDescriptorById.length)
                throw "Out of range path ID specified in request."

            @objectModel = objectModel_
            @objectModelSelectVector = objectModelSelectVector_
            @pathId = pathId_


            # Get the OM descriptor associated with the specified OM path.

            @objectModelDescriptor = @objectModel.objectModelDescriptorById[pathId_]
            if not (@objectModelDescriptor? and @objectModelDescriptor)
                throw "Unable to resolve object model descriptor for path #{objectModelPath_}"

            @selectKeysRequired = @objectModelDescriptor.pathResolveExtensionPoints.length
            @selectKeysProvided = objectModelSelectVector_? and objectModelSelectVector_ and objectModelSelectVector_.length or 0

            if @selectKeysRequired != @selectKeysProvided
                throw "Unable to resolve object model selector. Expected #{@selectKeysRequired} select keys. #{@selectKeysProvided} keys were provided."

        catch exception
            throw "Encapsule.code.lib.omm.ObjectSelector construction fail: #{exception}"
# ****************************************************************************
#


    


# ****************************************************************************
#


#
# ****************************************************************************
class Encapsule.code.lib.omm.Object
    constructor: (objectModelDeclaration_, jsonString_) ->
        try
            Console.message("Encapsule.code.lib.omm.Object construction.")

            # Validate parameter.
            if not (objectModelDeclaration_? and objectModelDeclaration_) then throw "Missing object model declaration parameter!"

            @objectModel = new Encapsule.code.lib.omm.ObjectModel(objectModelDeclaration_)

            @jsonTag = @objectModel.jsonTag
            @label = @objectModel.label
            @description = @objectModel.description
            @objectData = {}

            @instancePrivateState = {}
            @instancePrivateState.objectDataRevision = 0
            @instancePrivateState.objectDataCreateTime = 0
            @instancePrivateState.objectDataUpdateTime = 0

            #
            # ============================================================================
            @fromJSON = (jsonString_) =>
                try
                    Console.message("Encapsule.code.lib.omm.Object.initializeFromJSON for object #{@jsonTag}")
                    if not (jsonString_? and jsonString_)
                        throw "Missing JSON string input parameter!"
                    deserializedObject = JSON.parse(jsonString_) or {}
                    if not (deserializedObject? and deserializedObject)
                        throw "Cannot deserialized Javascript object from JSON!"
                    @objectData = deserializedObject[@jsonTag]
                    

                catch exception
                    throw "Encapsule.code.lib.omm.Object.fromJson fail on object #{@jsonTag} : #{exception}"

            #
            # ============================================================================
            @toJSON = =>
                try
                    Console.message("Encapsule.code.lib.omm.Object.toJSON for obejct #{@jsonTag}")
                    resultObject = {}
                    resultObject[@jsonTag] = @objectData
                    resultJSON = JSON.stringify(resultObject)
                    if not (resultJSON? and resultJSON)
                        throw "Cannot serialize Javascript object to JSON!"
                    return resultJSON

                catch exception
                    throw "Encapsule.code.lib.omm.Object.toJSON fail on object #{@jsonTag} : #{exception}"


            #
            # ============================================================================
            @getPathIdFromPath = (objectModelPath_) =>
                try
                    if not (@objectModel? and @objectModel) then throw "Internal error: Unable to resolve internal object model instance!"
                    if not (objectModelPath_? and objectModelPath_) then throw "Missing object model path parameter!"

                    objectModelDescriptor = @objectModel.objectModelPathMap[objectModelPath_]
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Internal error: Unable to resolve object model descriptor!"
        
                    objectModelPathId = objectModelDescriptor.id
                    if not objectModelPathId?
                        throw "Internal error: Unable to resolve object model path ID from object model descriptor."

                    return objectModelPathId

                catch exception
                    throw "Encapsule.code.lib.omm.Object.getPathIdFromPath fail: #{exception}"


            #
            # ============================================================================
            @getPathFromPathId = (pathId_) =>
                try
                    if not (pathId_?) then throw "Missing path ID parameter!"

                    objectModelDescriptor = @objectModel.objectModelDescriptorById[pathId_]
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Unable to resolve object descriptor for path ID #{pathId_}"
                    path = objectModelDescriptor.path
                    return path

                catch exception
                    throw "Encapsule.code.lib.omm.Object.getPathFromPathId fail: #{exception}"



            #
            # ============================================================================
            @getSelector = (pathId_, selectKeyVector_) =>
                try
                    if not pathId_? then throw "Missing object model path ID input parameter!"

                    selector = new Encapsule.code.lib.omm.ObjectModelSelector(@objectModel, pathId_, selectKeyVector_)
                    if not (selector? and selector)
                        throw "Unable to resolve selector for path ID #{pathId_}"
                    return selector

                catch exception
                    throw "Encapsule.code.lib.omm.Object.getNamespaceProxy fail on object #{@jsonTag} : #{exception}"


            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================


        catch exception
            throw "Encapsule.code.lib.omm.Object construction failed: #{exception}"


        

        
