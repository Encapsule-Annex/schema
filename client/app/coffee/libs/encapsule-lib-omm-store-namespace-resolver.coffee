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



class Encapsule.code.lib.omm.ObjectStoreNamespaceKeyResolver

    store: undefined
    resolvedSelectKey: undefined
    dataReference: undefined

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
                key: namespaceKey
                dataReference: namespaceKey? and namespaceKey and parentDataReference_[namespaceKey] or undefined
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
                        if objectModelDescriptor_.mvvmType = "archetype"
                            result.key = namespaceActions.getUniqueKey(namespaceObject)
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
            throw "Encapsule.code.lib.omm.ObjectStoreNamespaceKeyResolver.internalResolveNamespaceDescriptor failure: #{exception}"



    #
    # ============================================================================
    constructor: (store_, parentDataReference_, modelSelectKey_, mode_) ->
        try
            if not (store_? and store_) then throw "Missing object store input parameter."
            @dataReference = store_.dataReference? and store_.dataReference or store_.dataReference = {}
            if not (modelSelectKey_? and modelSelectKey_) then throw "Missing object model select key object input parameter."
            if not (mode_? and mode_) then throw "Missing mode input parameter."

            @resolvedSelectKey = modelSelectKey_.clone()

            objectModel = objectStore_.objectModel

            targetNamespaceDescriptor = objectModel.getNamespaceDescriptorFromPathId(modelSelectKey_.select.idNamespace)








        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespaceResolver failure: #{exception}"





