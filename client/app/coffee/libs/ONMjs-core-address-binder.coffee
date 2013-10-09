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
Encapsule.code.lib.onm = Encapsule.code.lib.onm? and Encapsule.code.lib.onm or @Encapsule.code.lib.onm = {}

ONMjs = Encapsule.code.lib.onm
ONMjs.implementation = ONMjs.implementation? and ONMjs.implementation or ONMjs.implementation = {}
ONMjs.implementation.binding = ONMjs.implementation.binding? and ONMjs.implementation.binding or ONMjs.implementation.binding = {}



#
# ****************************************************************************
ONMjs.implementation.binding.InitializeNamespaceProperties = (data_, descriptor_) ->
    try
        if not (data_? and data_) then throw "Missing data reference input parameter."
        if not (descriptor_? and descriptor_) then throw "Missing descriptor input parameter."

        if descriptor_.userImmutable? and descriptor_.userImmutable
            for memberName, functions of descriptor_.userImmutable
                if functions.fnCreate? and functions.fnCreate
                    data_[memberName] = functions.fnCreate()
        if descriptor_.userMutable? and descriptor_.userMutable
            for memberName, functions of descriptor_.userMutable
                if functions.fnCreate? and functions.fnCreate
                    data_[memberName] = functions.fnCreate()
        return true

    catch exception
        throw "ONMjs.implementation.binding.InitializeNamespaceProperties failure #{exception}."


#
# ****************************************************************************
ONMjs.implementation.binding.VerifyNamespaceProperties = (data_, descriptor_) ->
    try
        if not (data_? and data_) then throw "Missing data reference input parameter."
        if not (descriptor_? and descriptor_) then throw "Missing descriptor input parameter."

        if descriptor_.userImmutable? and descriptor_.userImmutable
            for memberName, functions of descriptor_.userImmutable
                memberReference = data_[memberName]
                if not memberReference?
                    throw "Expected immutable member '#{memberName}' not found."

        if descriptor_.userMutable? and descriptor_.userMutable
            for memberName, functions of descriptor_.userMutable
                memberReference = data_[memberName]
                if not memberReference?
                    throw "Expected mutable member '#{memberName}' not found."
        return true

    catch exception
        throw "ONMjs.implementation.binding.VerifyNamespaceMembers failure #{exception}."


#
# ****************************************************************************
ONMjs.implementation.binding.InitializeComponentNamespaces = (store_, data_, descriptor_, extensionPointId_, key_) ->
    try
        if not (data_? and data_) then throw "Missing data reference input parameter."
        if not (descriptor_? and descriptor_) then throw "Missing descriptor input parameter."
        if not (extensionPointId_? and extensionPointId_) then throw "Missing extension point ID input parameter."

        for childDescriptor in descriptor_.children
            if childDescriptor.namespaceType != "component"
                resolveResults = ONMjs.implementation.binding.ResolveNamespaceDescriptor({}, store_, data_, childDescriptor, key_, "new")
                ONMjs.implementation.binding.InitializeComponentNamespaces(store_, resolveResults.dataReference, childDescriptor, extensionPointId_, key_)

        return true

    catch exception
        throw "ONMjs.implementation.binding.InitializeComponentNamespaces failure: #{exception}."


#
# ****************************************************************************
ONMjs.implementation.binding.VerifyComponentNamespaces = (store_, data_, descriptor_, extensionPointId_) ->
    try
        if not (data_? and data_) then throw "Missing data reference input parameter."
        if not (descriptor_? and descriptor_) then throw "Missing descriptor input parameter."

        return true

    catch exception
        throw "ONMjs.implementation.binding.VerifyComponentNamespaces failure: #{exception}."



#
# ****************************************************************************
ONMjs.implementation.binding.ResolveNamespaceDescriptor = (resolveActions_, store_, data_, descriptor_, key_, mode_) ->
    try

        if not (resolveActions_? and resolveActions_) then throw "Internal error: missing resolve actions structure input parameter."
        if not (data_? and data_) then throw "Internal error: missing parent data reference input parameter."
        if not (descriptor_? and descriptor_) then throw "Internal error: missing object model descriptor input parameter."
        if not (mode_? and mode_) then throw "Internal error: missing mode input parameter."

        jsonTag =  ((descriptor_.namespaceType != "component") and descriptor_.jsonTag) or key_ or undefined

        resolveResults =
            jsonTag: jsonTag
            dataReference: jsonTag? and jsonTag and data_[jsonTag] or undefined
            dataParentReference: data_
            key: key_
            mode: mode_
            descriptor: descriptor_
            store: store_
            created: false

        switch mode_
            when "bypass"
                if not (resolveResults.dataReference? and resolveResults.dataReference)
                    throw "Internal error: Unable to resolve #{descriptor_.namespaceType} namespace descriptor in bypass mode."
                break
            when "new"
                if (resolveResults.dataReference? and resolveResults.dataReference)
                    break

                newData = {}
                ONMjs.implementation.binding.InitializeNamespaceProperties(newData, descriptor_.namespaceModelPropertiesDeclaration)

                if descriptor_.namespaceType == "component"
                    if not (resolveActions_.getUniqueKey? and resolveActions_.getUniqueKey)
                        throw "In order to create new components at runtime you must define the semanticBindings.getUniqueKey function in your data model declaration object."
                    resolveResults.key = resolveResults.jsonTag = resolveActions_.getUniqueKey(newData)
                    if not (resolveResults.key? and resolveResults.key)
                        throw "Unable to obtain key for new data component from function semanticBindings.getUniqueKey."

                resolveResults.dataReference = resolveResults.dataParentReference[resolveResults.jsonTag] = newData
                resolveResults.created = true

                break

            when "strict"
                if not (resolveResult.dataReference? and resolveResult.dataReference)
                    throw "Internal error: Unable to resolve  #{descriptor_.namespaceType} namespace descriptor in strict mode."
                ONMjs.implementation.binding.VerifyNamespaceProperties(result.dataReference, descriptor_.namespaceModelPropertiesDeclaration)
                break
            else
                throw "Unrecognized mode parameter value."

        return resolveResults

    catch exception
        throw "ONMjs.implementation.binding.ResolveNamespaceDescriptor failure: #{exception}"




#
# ****************************************************************************
class ONMjs.implementation.AddressTokenBinder
    constructor: (store_, parentDataReference_, token_, mode_) ->
        try
            @store = store_? and store_ or throw "Missing object store input parameter."
            model = store_.model
            @parentDataReference = parentDataReference_? and parentDataReference_ or throw "Missing parent data reference input parameter."
            if not (token_? and token_) then throw "Missing object model address token object input parameter."
            if not (mode_? and mode_) then throw "Missing mode input parameter."

            @dataReference = undefined
            @resolvedToken = token_.clone()

            targetNamespaceDescriptor = token_.namespaceDescriptor
            targetComponentDescriptor = token_.componentDescriptor

            semanticBindings = model.getSemanticBindings()
            getUniqueKeyFunction = semanticBindings? and semanticBindings and semanticBindings.getUniqueKey? and semanticBindings.getUniqueKey or undefined

            resolveActions = {
                getUniqueKey: getUniqueKeyFunction
            }

            # Resolve the input token's component namespace.
            resolveResults = ONMjs.implementation.binding.ResolveNamespaceDescriptor(resolveActions, store_, @parentDataReference, token_.componentDescriptor, token_.key, mode_)
            @dataReference = resolveResults.dataReference

            if resolveResults.created
                @resolvedToken.key = resolveResults.key

            extensionPointId = token_.extensionPointDescriptor? and token_.extensionPointDescriptor and token_.extensionPointDescriptor.id or -1

            if mode_ == "new" and resolveResults.created
                ONMjs.implementation.binding.InitializeComponentNamespaces(store_, @dataReference, targetComponentDescriptor, extensionPointId, @resolvedToken.key)

            if mode_ == "strict"
                ONMjs.implementation.binding.VerifyComponentNamespaces(store_, resolveResult.dataReference, targetComponentDescriptor, extensionPointId)            

            # ... If we've been asked to bind the root namespace of the component then we're done.

            if targetNamespaceDescriptor.isComponent
                return

            # ... otherwise the request is to bind a subnamespace of the component we just bound (i.e. created or opened depending on mode) above.

            # How many ranks above us in the parent/child tree is the requested subnamespace?
            generations = targetNamespaceDescriptor.parentPathIdVector.length - targetComponentDescriptor.parentPathIdVector.length - 1

            # Parent path ID's of the parent namespaces (i.e. child namespaces of the current data reference)
            parentPathIds = generations and targetNamespaceDescriptor.parentPathIdVector.slice(-generations) or []

            # ... Resolve the component subnamespace parents of the target namespace.
            for pathId in parentPathIds
                descriptor = model.implementation.getNamespaceDescriptorFromPathId(pathId)
                resolveResults = ONMjs.implementation.binding.ResolveNamespaceDescriptor(resolveActions, store_, resolveResults.dataReference, descriptor, resolveResults.key, mode_)

            # ... Resolve the target namespace
            resolveResults = ONMjs.implementation.binding.ResolveNamespaceDescriptor(resolveActions, store_, resolveResults.dataReference, targetNamespaceDescriptor, resolveResults.key, mode_)
            @dataReference = resolveResults.dataReference

            return

            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------

        catch exception
            throw "ONMjs.implementation.AddressTokenBinder failure: #{exception}"


