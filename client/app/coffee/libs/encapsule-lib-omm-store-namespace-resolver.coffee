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

    store: undefined
    resolvedSelectKey: undefined
    dataReference: undefined

    #
    # ============================================================================
    constructor: (store_, parentDataReference_, modelSelectKey_, mode_) ->
        try

            if not (modelSelectKey_? and modelSelectKey_) then throw "Missing object model select key object input parameter."
            if not (mode_? and mode_) then throw "Missing mode input parameter."

            parentDataReference = (parentDataReference_? and parentDataReference_) or (store_.dataReference? and store_.dataReference or store_.dataReference = {})

            @resolvedSelectKey = modelSelectKey_.clone()

            objectModel = store_.objectModel

            targetNamespaceDescriptor = modelSelectKey_.namespaceDescriptor
            targetComponentDescriptor = modelSelectKey_.componentDescriptor

            resolveResult = @internalResolveNamespaceDescriptor(store_, parentDataReference, targetComponentDescriptor, modelSelectKey_.key, mode_)

            if targetNamespaceDescriptor.isComponent
                if resolveResult.newSelectKey then @resolvedSelectKey.key = resolveResult.key
                @dataReference = resolveResult.dataReference
                return

            # Resolve the target namespace relative to its component root.
            targetNamespaceHeightOverComponent = targetNamespaceDescriptor.parentPathIdVector.length - targetComponentDescriptor.parentPathIdVector.length - 1
            pathIdsToProcess = targetNamespaceDescriptor.parentPathIdVector.slice(-targetNamespaceHeightOverComponent)

            for pathId in pathIdsToProcess
                descriptor = objectModel.getNamespaceDescriptorFromPathId(pathId)
                resolveResult = @internalResolveNamespaceDescriptor(store_, resolveResult.dataReference, descriptor, undefined, mode_)
            resolveResult = @internalResolveNamespaceDescriptor(store_, resolveResult.dataReference, targetNamespaceDescriptor, undefined, mode_)
            @dataReference = resolveResult.dataReference
            return

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespaceResolver failure: #{exception}"


    #
    # ============================================================================
    internalResolveNamespaceDescriptor: (store_, parentDataReference_, objectModelDescriptor_, key_, mode_) ->
        try

            if not (parentDataReference_? and parentDataReference_) then throw "Internal error: missing parent data reference input parameter."
            if not (objectModelDescriptor_? and objectModelDescriptor_) then throw "Internal error: missing object model descriptor input parameter."
            if not (mode_? and mode_) then throw "Internal error: missing mode input parameter."

            # Mock these for now
            namespaceActions = {
                initialize: (dataReference_, namespaceDescriptor_) ->
                verify: (dataReference_, namespaceDescriptor_) ->
                getUniqueKey: -> uuid.v4()
            }

            namespaceKey = ((objectModelDescriptor_.mvvmType != "archetype") and objectModelDescriptor_.jsonTag) or key_ or undefined

            result = {
                key: undefined
                dataReference: namespaceKey? and namespaceKey and parentDataReference_[namespaceKey] or undefined
                newSelectKey: false
            }

            switch mode_
                when "bypass"
                    if not (result.dataReference? and result.dataReference)
                        throw "Internal error: Unable to resolve #{objectModelDescriptor_.mvvmType} namespace descriptor in bypass mode."
                    break
                when "new"
                    if not (result.dataReference? and result.dataReference)
                        namespaceObject = {}
                        namespaceActions.initialize(namespaceObject, objectModelDescriptor_.namespaceDescriptor)
                        if objectModelDescriptor_.mvvmType == "archetype"
                            namespaceKey = result.key = namespaceActions.getUniqueKey(namespaceObject)
                            if not (namespaceKey? and namespaceKey)
                                throw "Error obtaining a unique ID for this component."
                            result.newSelectKey = true
                        result.dataReference =  parentDataReference_[namespaceKey] = namespaceObject
                    break
                when "strict"
                    if not (result.dataReference? and result.dataReference)
                        throw "Internal error: Unable to resolve  #{objectModelDescriptor_.mvvmType} namespace descriptor in strict mode."
                    namespaceActions.verify(result.dataReference, objectModelDescriptor_.namespaceDescriptor)
                    break
                else
                    throw "Unrecognized mode parameter value."

            return result

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespaceResolver.internalResolveNamespaceDescriptor failure: #{exception}"





