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


Encapsule.code.lib.omm.RootObjectDescriptorFactory = (jsonTag_, label_, description_, menuHierarchy_) ->
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


            # --------------------------------------------------------------------------
            #
            processObjectModelDescriptor = (objectModelDescriptor_, path_, rank_) =>
                # \ BEGIN: processObjectModelDescriptor

                tag = objectModelDescriptor_.jsonTag

                path = undefined
                if path_? and path_
                    path = "#{path_}.#{tag}"
                else
                    path = "#{tag}"

                rank = rank_? and rank_ or 0

                id = @descriptorCount
                @descriptorCount++

                thisObjectModelDescriptor = @objectModelDescriptorById[id] = {
                    "id": id
                    "rank": rank,
                    "jsonTag": objectModelDescriptor_.jsonTag,
                    "path": path
                     }

                @objectModelPathMap[path] = thisObjectModelDescriptor

                mvvmType = objectModelDescriptor_.objectDescriptor.mvvmType
                extensionObjectDescriptor = objectModelDescriptor_.objectDescriptor.archetype

                if (mvvmType == "extension")
                    if not (extensionObjectDescriptor? and extensionObjectDescriptor)
                        throw "Cannot resolve extension object descriptor."

                    @objectModelExtensionPointMap[path] = thisObjectModelDescriptor
                    processObjectModelDescriptor(extensionObjectDescriptor, path, rank + 1)


                if (mvvmType == "archetype")
                    @objectModelExtensionMap[path] = thisObjectModelDescriptor


                if not (objectModelDescriptor_.subMenus? and objectModelDescriptor_.subMenus)
                    return

                for subObjectDescriptor in objectModelDescriptor_.subMenus
                     processObjectModelDescriptor(subObjectDescriptor, path, rank + 1)

                # / END: processObjectModelDescriptor



            @objectModelPathMap = {}
            @objectModelDescriptorById = []
            @objectModelExtensionPointMap = {}
            @objectModelExtensionMap = {}
            @descriptorCount = 0
            processObjectModelDescriptor(rootObjectDescriptor)


        catch exception
            throw "Encapsule.code.lib.omm.ObjectModel construction fail: #{exception}"




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


        

        
