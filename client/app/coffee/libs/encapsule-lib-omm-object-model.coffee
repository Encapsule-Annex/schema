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
            rootObjectDescriptor = Encapsule.code.lib.omm.implementation.RootObjectDescriptorFactory(
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
            # objectModelDescriptor = (required) reference to OM layout declaration object
            # path = (optional/used in recursion) parent descriptor's OM path (defaults to jsonTag if undefined)
            # rank = (optional/used in recursion) directed graph rank (aka level - a zero-based count of tree depth)
            # parentDescriptor_ = (optional/used in recursion) 

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
