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
# encapsule-lib-omm-object-store-namespace-resolver.coffee
#
# OMM stands for Object Model Manager
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}



class Encapsule.code.lib.omm.ObjectStoreNamespaceResolver
    constructor: (store_, parentDataReference_, modelSelectKey_, mode_) ->
        try

            # ----------------------------------------------------------------------------
            localInitializeNamespaceMembers = (data_, descriptor_) ->
                try
                    if not (data_? and data_ and descriptor_? and descriptor_)
                        throw "Attempt to initialize namespace members with invalid data reference or namespace descriptor."

                    if descriptor_.userImmutable? and namespaceDescriptor_.userImmutable
                        for memberName, functions of descriptor_.userImmutable
                            if functions.fnCreate? and functions.fnCreate
                                data_[memberName] = functions.fnCreate()

                    if descriptor_.userMutable? and namespaceDescriptor_.userMutable
                        for memberName, functions of descriptor_.userMutable
                            if functions.fnCreate? and functions.fnCreate
                                data_[memberName] = functions.fnCreate()

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStoreNamespace.internalInitializeNamespaceMembers failure '#{exception}'."

            # ----------------------------------------------------------------------------
            localVerifyNamespaceMembers = (data_, descriptor_) ->
                try
                    if not (data_? and data_ and descriptor_? and descriptor_)
                        return
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
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStoreNamespace.internalVerifyNamespaceMembers failure '#{exception}'."

            # ----------------------------------------------------------------------------
            localResolveNamespaceDescriptor = (store_, data_, descriptor_, key_, mode_) ->
                try

                    if not (data_? and data_) then throw "Internal error: missing parent data reference input parameter."
                    if not (descriptor_? and descriptor_) then throw "Internal error: missing object model descriptor input parameter."
                    if not (mode_? and mode_) then throw "Internal error: missing mode input parameter."

                    # Mock these for now
                    namespaceActions = {
                        initialize: (dataReference_, descriptor_) ->
                        verify: (dataReference_, descriptor_) ->
                        getUniqueKey: -> uuid.v4()
                    }

                    namespaceKey = ((descriptor_.mvvmType != "archetype") and descriptor_.jsonTag) or key_ or undefined

                    result = {
                        key: undefined
                        dataReference: namespaceKey? and namespaceKey and data_[namespaceKey] or undefined
                        newSelectKey: false
                    }

                    switch mode_
                        when "bypass"
                            if not (result.dataReference? and result.dataReference)
                                throw "Internal error: Unable to resolve #{descriptor_.mvvmType} namespace descriptor in bypass mode."
                            break
                        when "new"
                            if not (result.dataReference? and result.dataReference)
                                namespaceObject = {}
                                namespaceActions.initialize(namespaceObject, descriptor_.namespaceDescriptor)
                                if descriptor_.mvvmType == "archetype"
                                    namespaceKey = result.key = namespaceActions.getUniqueKey(namespaceObject)
                                    if not (namespaceKey? and namespaceKey)
                                        throw "Error obtaining a unique ID for this component."
                                    result.newSelectKey = true
                                result.dataReference =  data_[namespaceKey] = namespaceObject
                            break
                        when "strict"
                            if not (result.dataReference? and result.dataReference)
                                throw "Internal error: Unable to resolve  #{descriptor_.mvvmType} namespace descriptor in strict mode."
                            namespaceActions.verify(result.dataReference, descriptor_.namespaceDescriptor)
                            break
                        else
                            throw "Unrecognized mode parameter value."

                    return result

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStoreNamespaceResolver.internalResolveNamespaceDescriptor failure: #{exception}"


            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------

            @store = store_? and store_ or throw "Missing object store input parameter."
            objectModel = store_.objectModel
            parentDataReference = parentDataReference_? and parentDataReference_ or throw "Missing parent data reference input parameter."
            if not (modelSelectKey_? and modelSelectKey_) then throw "Missing object model select key object input parameter."
            if not (mode_? and mode_) then throw "Missing mode input parameter."
            @dataReference = undefined
            @resolvedSelectKey = modelSelectKey_.clone()

            targetNamespaceDescriptor = modelSelectKey_.namespaceDescriptor
            targetComponentDescriptor = modelSelectKey_.componentDescriptor

            resolveResult = localResolveNamespaceDescriptor(store_, parentDataReference, targetComponentDescriptor, modelSelectKey_.key, mode_)

            if targetNamespaceDescriptor.isComponent
                if resolveResult.newSelectKey then @resolvedSelectKey.key = resolveResult.key
                @dataReference = resolveResult.dataReference
                return

            # Resolve the target namespace relative to its component root.
            targetNamespaceHeightOverComponent = targetNamespaceDescriptor.parentPathIdVector.length - targetComponentDescriptor.parentPathIdVector.length - 1
            pathIdsToProcess = targetNamespaceDescriptor.parentPathIdVector.slice(-targetNamespaceHeightOverComponent)

            for pathId in pathIdsToProcess
                descriptor = objectModel.getNamespaceDescriptorFromPathId(pathId)
                resolveResult = localResolveNamespaceDescriptor(store_, resolveResult.dataReference, descriptor, undefined, mode_)
            resolveResult = localResolveNamespaceDescriptor(store_, resolveResult.dataReference, targetNamespaceDescriptor, undefined, mode_)
            @dataReference = resolveResult.dataReference
            return

            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespaceResolver failure: #{exception}"


