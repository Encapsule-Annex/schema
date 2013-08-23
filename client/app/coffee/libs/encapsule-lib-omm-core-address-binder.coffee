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
# encapsule-lib-omm-core-address-binder.coffee
#


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.core = Encapsule.code.lib.omm.core? and Encapsule.code.lib.omm.core or @Encapsule.code.lib.omm.core = {}



class Encapsule.code.lib.omm.AddressTokenBinder
    constructor: (store_, parentDataReference_, modelSelectKey_, mode_, dataReferenceAsComponentRoot_) ->
        try

            # ----------------------------------------------------------------------------
            localInitializeNamespaceMembers = (data_, descriptor_) ->
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

                catch exception
                    throw "Encapsule.code.lib.omm.AddressTokenBinder.localInitializeNamespaceMembers failure #{exception}."

            # ----------------------------------------------------------------------------
            localVerifyNamespaceMembers = (data_, descriptor_) ->
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
                catch exception
                    throw "Encapsule.code.lib.omm.AddressTokenBinder.localVerifyNamespaceMembers failure #{exception}."


            # ----------------------------------------------------------------------------
            localInitializeComponent = (store_, data_, descriptor_, extensionPointId_) ->
                try
                    if not (data_? and data_) then throw "Missing data reference input parameter."
                    if not (descriptor_? and descriptor_) then throw "Missing descriptor input parameter."
                    if not descriptor_.isComponent then throw "Input descriptor does not specifiy a component in this object model."
                    if not (extensionPointId_? and extensionPointId_) then throw "Missing extension point ID input parameter."

                    for pathId in descriptor_.componentNamespaceIds
                        if pathId == descriptor_.id then continue
                        addressToken = new Encapsule.code.lib.omm.AddressToken(store_.objectModel, extensionPointId_, undefined, pathId)
                        resolvedNamespace = new Encapsule.code.lib.omm.AddressTokenBinder(store_, data_, addressToken, "new", true)

                catch exception
                    throw "Encapsule.code.lib.omm.AddressTokenBinder.localInitializeComponent failure: #{exception}."



            # ----------------------------------------------------------------------------
            localVerifyComponent = (store_, data_, descriptor_, extensionPointId_) ->
                try
                    if not (data_? and data_) then throw "Missing data reference input parameter."
                    if not (descriptor_? and descriptor_) then throw "Missing descriptor input parameter."


                catch exception
                    throw "Encapsule.code.lib.omm.AddressTokenBinder.localVerifyComponent failure: #{exception}."






            # ----------------------------------------------------------------------------
            localResolveNamespaceDescriptor = (resolveActions_, store_, data_, descriptor_, key_, mode_) ->
                try

                    if not (resolveActions_? and resolveActions_) then throw "Internal error: missing resolve actions structure input parameter."
                    if not (data_? and data_) then throw "Internal error: missing parent data reference input parameter."
                    if not (descriptor_? and descriptor_) then throw "Internal error: missing object model descriptor input parameter."
                    if not (mode_? and mode_) then throw "Internal error: missing mode input parameter."

                    jsonTag = ((descriptor_.mvvmType != "archetype") and descriptor_.jsonTag) or key_ or undefined

                    result = {
                        jsonTag: jsonTag
                        dataReference: undefined
                        created: false
                        newKey: undefined
                    }

                    result.dataReference = jsonTag? and jsonTag and data_[jsonTag] or undefined

                    switch mode_
                        when "bypass"
                            if not (result.dataReference? and result.dataReference)
                                throw "Internal error: Unable to resolve #{descriptor_.mvvmType} namespace descriptor in bypass mode."
                            break
                        when "new"
                            if not (result.dataReference? and result.dataReference)
                                namespaceObject = {}
                                resolveActions_.initializeNamespace(namespaceObject, descriptor_.namespaceDescriptor)
                                if descriptor_.mvvmType == "archetype"
                                    jsonTag = result.jsonTag = result.newKey = resolveActions_.getUniqueKey(namespaceObject)
                                    if not (jsonTag? and jsonTag)
                                        throw "Error obtaining a unique ID for this component."
                                result.dataReference =  data_[jsonTag] = namespaceObject
                                result.created = true
                            break
                        when "strict"
                            if not (result.dataReference? and result.dataReference)
                                throw "Internal error: Unable to resolve  #{descriptor_.mvvmType} namespace descriptor in strict mode."
                            resolveActions_.verifyNamespace(result.dataReference, descriptor_.namespaceDescriptor)
                            break
                        else
                            throw "Unrecognized mode parameter value."

                    return result

                catch exception
                    throw "Encapsule.code.lib.omm.AddressTokenBinder.internalResolveNamespaceDescriptor failure: #{exception}"


            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------

            @store = store_? and store_ or throw "Missing object store input parameter."
            objectModel = store_.objectModel
            @parentDataReference = parentDataReference_? and parentDataReference_ or throw "Missing parent data reference input parameter."
            if not (modelSelectKey_? and modelSelectKey_) then throw "Missing object model select key object input parameter."
            if not (mode_? and mode_) then throw "Missing mode input parameter."
            @dataReference = undefined
            @dataReferenceAsComponentRoot = dataReferenceAsComponentRoot_? and dataReferenceAsComponentRoot_ or false

            @resolvedSelectKey = modelSelectKey_.clone()

            targetNamespaceDescriptor = modelSelectKey_.namespaceDescriptor
            targetComponentDescriptor = modelSelectKey_.componentDescriptor

            resolveActions = {
                initializeNamespace: localInitializeNamespaceMembers
                verifyNamespace: localVerifyNamespaceMembers
                getUniqueKey: objectModel.getSemanticBindings().getUniqueKey
            }

            resolveResult = {}
            if not @dataReferenceAsComponentRoot

                resolveResult = localResolveNamespaceDescriptor(resolveActions, store_, @parentDataReference, targetComponentDescriptor, modelSelectKey_.key, mode_)

                extensionPointId = modelSelectKey_.extensionPointDescriptor? and modelSelectKey_.extensionPointDescriptor or -1

                if mode_ == "new" and resolveResult.created
                    localInitializeComponent(store_, resolveResult.dataReference, targetComponentDescriptor, extensionPointId)

                if mode_ == "strict"
                    localVerifyComponent(store_, resolveResult.dataReference, targetComponentDescriptor, extensionPointId)            

                if targetNamespaceDescriptor.isComponent
                    if resolveResult.newKey? and resolveResult.newKey then @resolvedSelectKey.key = resolveResult.newKey
                    @dataReference = resolveResult.dataReference
                    return
            else
                resolveResult.dataReference = @parentDataReference

            # Resolve the target namespace relative to its component root.
            targetNamespaceHeightOverComponent = targetNamespaceDescriptor.parentPathIdVector.length - targetComponentDescriptor.parentPathIdVector.length - 1
            pathIdsToProcess = targetNamespaceHeightOverComponent and targetNamespaceDescriptor.parentPathIdVector.slice(-targetNamespaceHeightOverComponent) or []

            for pathId in pathIdsToProcess
                descriptor = objectModel.getNamespaceDescriptorFromPathId(pathId)
                resolveResult = localResolveNamespaceDescriptor(resolveActions, store_, resolveResult.dataReference, descriptor, undefined, mode_)
            resolveResult = localResolveNamespaceDescriptor(resolveActions, store_, resolveResult.dataReference, targetNamespaceDescriptor, undefined, mode_)
            @dataReference = resolveResult.dataReference
            return

            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------

        catch exception
            throw "Encapsule.code.lib.omm.AddressTokenBinder failure: #{exception}"


