###
------------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2013 Encapsule Project
  
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

**** Encapsule Project :: Build better software with circuit models ****

OPEN SOURCES: http://github.com/Encapsule HOMEPAGE: http://Encapsule.org
BLOG: http://blog.encapsule.org TWITTER: https://twitter.com/Encapsule

------------------------------------------------------------------------------



------------------------------------------------------------------------------

###
#
#
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}

ONMjs = Encapsule.code.lib.omm
ONMjs.implementation = ONMjs.implementation? and ONMjs.implementation or ONMjs.implementation = {}

#
# ****************************************************************************
ONMjs.implementation.RootObjectDescriptorFactory = (jsonTag_, label_, description_, menuHierarchy_) ->
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
        throw "ONMjs.implementation.RooObjectDescriptorFactor function failed: #{exception}"
# ****************************************************************************
#

#
#
# ****************************************************************************
class ONMjs.implementation.ModelBase
    constructor: (objectModelDeclaration_) ->
        try

            # --------------------------------------------------------------------------
            buildOMDescriptorFromLayout = (objectModelLayoutObject_, path_, parentDescriptor_, componentDescriptor_, parentPathIdVector_, parentPathExtensionPointIdVector_) =>
                try
                    if not (objectModelLayoutObject_? and objectModelLayoutObject_) then throw "Missing object model layout object input parameter! Typically this happens if you declare the object model namespace with an unresolvable reference (e.g. to an object you defined previously for re-use) as opposed to declaring inline in your object model declaration."

                    # Local variables used to construct this descriptor.
                    tag = objectModelLayoutObject_.jsonTag

                    path = path_? and path_ and "#{path_}.#{tag}" or tag

                    id = @countDescriptors
                    @countDescriptors++ # set up for the next invocation of this function (used the id var locally)

                    parentPathExtensionPoints = undefined
                    if parentPathExtensionPointIdVector_? and parentPathExtensionPointIdVector_
                        parentPathExtensionPoints = Encapsule.code.lib.js.clone parentPathExtensionPointIdVector_
                    else
                        parentPathExtensionPoints = []

                    mvvmType = objectModelLayoutObject_.objectDescriptor.mvvmType

                    # 

                    namespaceDeclaration = objectModelLayoutObject_.objectDescriptor.namespaceDescriptor? and objectModelLayoutObject_.objectDescriptor.namespaceDescriptor or {}

                    # Build this descriptor and add it to the OM's descriptor array.
                    thisDescriptor = @objectModelDescriptorById[id] = {
                        # valid only if mvvmType == "extension" (set to ID of extension point's corresponding archetype)
                        "archetypePathId": -1           
                        "children": []
                        "componentNamespaceIds": []
                        "description": objectModelLayoutObject_.objectDescriptor.description
                        # valid only if mvvmType == "archetype" (populated with extension point ID's that specify this archetype by reference)
                        "extensionPointReferenceIds": []
                        "id": id
                        "idComponent": id
                        "isComponent": false
                        "jsonTag": tag
                        "label": objectModelLayoutObject_.label
                        "mvvmType": mvvmType
                        "namespaceDescriptor": namespaceDeclaration
                        "parent": parentDescriptor_
                        "parentPathExtensionPoints": parentPathExtensionPoints # self-extensible objects makes this superfluous I think
                        "parentPathIdVector": []
                        "path":  path
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

                            processArchetypeDeclaration = undefined
                            archetypeDescriptor = undefined
                            if objectModelLayoutObject_.objectDescriptor.archetype? and objectModelLayoutObject_.objectDescriptor.archetype
                                processArchetypeDeclaration = true
                                archetypeDescriptor = objectModelLayoutObject_.objectDescriptor.archetype # may be undefined
                            else if objectModelLayoutObject_.objectDescriptor.archetypeReference? and objectModelLayoutObject_.objectDescriptor.archetypeReference
                                processArchetypeDeclaration = false
                                pathReference = objectModelLayoutObject_.objectDescriptor.archetypeReference
                                objectModelDescriptorReference = @objectModelPathMap[pathReference]
                                if not (objectModelDescriptorReference? and objectModelDescriptorReference)
                                    throw "Cannot process extension point declaration because its corresponding archetype reference '#{pathReference}' is not defined."
                                if objectModelDescriptorReference.mvvmType != "archetype"
                                    throw "Cannot process extension point declaration becuase it's corresponding archetype reference '#{pathReference}' does not refer to an 'archetype' namespace."
                                # Add the extension point ID to the archetype's list of extension points
                                # that specify it by reference.
                                objectModelDescriptorReference.extensionPointReferenceIds.push thisDescriptor.id

                                # Add the archetype's ID to this extension point's descriptor.
                                thisDescriptor.archetypePathId = objectModelDescriptorReference.id
                                @countExtensionReferences++

                            else
                                throw "Cannot process extension point declaration because its corresponding extension archetype is missing from the object model declaration."

                            updatedParentPathExtensionPointIdVector = Encapsule.code.lib.js.clone parentPathExtensionPoints
                            updatedParentPathExtensionPointIdVector.push id
                            @countExtensionPoints++

                            # *** RECURSION (conditionally based on if the extension point defines its own archetype or referes to another by its path string)
                            if processArchetypeDeclaration
                                buildOMDescriptorFromLayout(archetypeDescriptor, path, thisDescriptor, componentDescriptor, thisDescriptor.parentPathIdVector, updatedParentPathExtensionPointIdVector)

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
            Console.message("ONMjs.Model: Processing object model declaration '#{objectModelDeclaration_.jsonTag}'")

            if not (objectModelDeclaration_? and objectModelDeclaration_)
                throw "Missing object model delcaration input parameter!"

            @jsonTag = objectModelDeclaration_.jsonTag
            @label = objectModelDeclaration_.label
            @description = objectModelDeclaration_.description
            
            # Create the root object descriptor (note that this is a generic descriptor shared by all
            # instances of ObjectModel. The namespace is reserved for use by OMM itself and cannot be
            # accessed via the object model layout declaration object.

            rootObjectDescriptor = ONMjs.implementation.RootObjectDescriptorFactory(
                @jsonTag
                @label
                @description
                objectModelDeclaration_.menuHierarchy
                )

            # ObjectModel instances take a deep copy of objectModelDeclaration_
            @objectModelDeclaration = Encapsule.code.lib.js.clone objectModelDeclaration_

            if not (@objectModelDeclaration? and @objectModelDeclaration)
                throw "Failed to clone source object model declaration."

            # Note that we patch our _copy_ of the declaration in order to splice in the
            # auto-generated root namespace leaving the original declaration unchanged.
            @objectModelDeclaration.menuHierarchy = [ rootObjectDescriptor ]

            #
            # objectModelDescriptor = (required) reference to OM layout declaration object
            # path = (optional/used in recursion) parent descriptor's OM path (defaults to jsonTag if undefined)
            # rank = (optional/used in recursion) directed graph rank (aka level - a zero-based count of tree height)
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
            @countExtensionReferences = 0
            @countChildren = 0
            @rankMax = 0

            # *** START RECURSION
            buildOMDescriptorFromLayout(rootObjectDescriptor)

            # Some basic consistency checks to ensure that completely screwed up declaratons
            # aren't foisted upon unsuspecting observers.

            if @countExtensionPoints != @countExtensions + @countExtensionReferences
                throw "Layout declaration error: extension point and extension descriptor counts do not match. countExtensionPoints=#{@countExtensionPoints} countExtensions=#{@countExtensions}"

            if @countComponents != @countExtensionPoints + 1 - @countExtensionReferences
                throw "Layout declaration error: component count should be " +
                     "extension count + 1 - extension references. componentCount=#{@countComponents} " +
                     " countExtensions=#{@countExtensions} extensionReferences=#{@countExtensionReferences}"

            # Debug summary output.
            Console.message("... '#{@jsonTag}' root descriptor")
            Console.message("... #{@countChildren} child descriptor(s)")
            Console.message("... #{@countExtensionPoints} extension point descriptor(s)")
            Console.message("... #{@countExtensions} extension descriptor(s)")
            Console.message("... #{@countExtensionReferences} extension reference(s)")
            Console.message("... <strong>#{@countDescriptors} total namespace declarations processed.</strong>")
            Console.message("... ... #{@countComponents} composable components / tallest leaf = rank #{@rankMax}")


        catch exception
            throw "ONMjs.ModelBase object model declaration parse failure: #{exception}. Check your ONMjs object model declaration carefully for error(s)."

# ****************************************************************************
#


#
#
# ****************************************************************************
class ONMjs.Model extends ONMjs.implementation.ModelBase
    constructor: (objectModelDeclaration_) ->
        try
            super(objectModelDeclaration_)

            # --------------------------------------------------------------------------
            @getNamespaceDescriptorFromPathId = (pathId_) =>
                try
                    if not (pathId_?) then throw "Missing path ID parameter!"
                    if (pathId_ < 0) or (pathId_ >= @objectModelDescriptorById.length)
                        throw "Out of range path ID '#{pathId_} cannot be resolved."

                    objectModelDescriptor = @objectModelDescriptorById[pathId_]
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Internal error getting namespace descriptor for path ID=#{pathId_}!"
                    return objectModelDescriptor

                catch exception
                    throw "ONMjs.Model.getNamespaceDescriptorFromPathId failure: #{exception}"
                
            # --------------------------------------------------------------------------
            @getPathIdFromPath = (objectModelPath_) =>
                try
                    if not (objectModelPath_? and objectModelPath_) then throw "Missing object model path parameter!"

                    objectModelDescriptor = @objectModelPathMap[objectModelPath_]
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Invalid object model path '#{objectModelPath_}' cannot be resolved."
        
                    objectModelPathId = objectModelDescriptor.id
                    if not objectModelPathId?
                        throw "Internal error: Invalid object model descriptor doesn't support id property for path '#{objectModelPath_}."

                    return objectModelPathId

                catch exception
                    throw "ONMjs.Model.getPathIdFromPath fail: #{exception}"

            # --------------------------------------------------------------------------
            @getPathFromPathId = (pathId_) =>
                try
                    objectModelDescriptor = @getNamespaceDescriptorFromPathId(pathId_)
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Internal error: Can't find object descriptor for valid path ID '#{pathId_}."
                    path = objectModelDescriptor.path
                    if not (path? and path)
                        throw "Internal error: Invalid object model descriptor doesn't support path property for path '#{objectModelPath_}."
                    return path

                catch exception
                    throw "ONMjs.Model.getPathFromPathId fail: #{exception}"


            # --------------------------------------------------------------------------
            @getSemanticBindings = =>
                try
                    semanticBindings = @objectModelDeclaration.semanticBindings
                    return semanticBindings
                catch exception
                    throw "ONMjs.Model failure: #{exception}"



        catch exception
            throw "ONMjs.Model construction fail: #{exception}"
