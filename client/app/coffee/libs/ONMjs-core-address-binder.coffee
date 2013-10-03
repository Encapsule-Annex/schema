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

###
Encapsule.code.lib.onm.AddressTokenBinder is an internal implementation class of the ONM library.
You should avoid this class unless you're extending the core ONM library classes or fixing a bug.
###

class ONMjs.implementation.AddressTokenBinder
    constructor: (store_, parentDataReference_, token_, mode_, dataReferenceAsComponentRoot_) ->
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
                    throw "ONMjs.implementation.AddressTokenBinder.localInitializeNamespaceMembers failure #{exception}."

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
                    throw "ONMjs.implementation.AddressTokenBinder.localVerifyNamespaceMembers failure #{exception}."


            # ----------------------------------------------------------------------------
            localInitializeComponent = (store_, data_, descriptor_, extensionPointId_) ->
                try
                    if not (data_? and data_) then throw "Missing data reference input parameter."
                    if not (descriptor_? and descriptor_) then throw "Missing descriptor input parameter."
                    if not descriptor_.isComponent then throw "Input descriptor does not specifiy a component in this object model."
                    if not (extensionPointId_? and extensionPointId_) then throw "Missing extension point ID input parameter."

                    for pathId in descriptor_.componentNamespaceIds
                        if pathId == descriptor_.id then continue
                        addressToken = new ONMjs.AddressToken(store_.model, extensionPointId_, undefined, pathId)
                        # Note the special-case use of the dataReferenceAsComponentRoot_ flag in this case.
                        resolvedNamespace = new ONMjs.implementation.AddressTokenBinder(store_, data_, addressToken, "new", true)

                catch exception
                    throw "ONMjs.implementation.AddressTokenBinder.localInitializeComponent failure: #{exception}."


            # ----------------------------------------------------------------------------
            localVerifyComponent = (store_, data_, descriptor_, extensionPointId_) ->
                try
                    if not (data_? and data_) then throw "Missing data reference input parameter."
                    if not (descriptor_? and descriptor_) then throw "Missing descriptor input parameter."


                catch exception
                    throw "ONMjs.implementation.AddressTokenBinder.localVerifyComponent failure: #{exception}."


            # ----------------------------------------------------------------------------
            localResolveNamespaceDescriptor = (resolveActions_, store_, data_, descriptor_, key_, mode_) ->
                try

                    if not (resolveActions_? and resolveActions_) then throw "Internal error: missing resolve actions structure input parameter."
                    if not (data_? and data_) then throw "Internal error: missing parent data reference input parameter."
                    if not (descriptor_? and descriptor_) then throw "Internal error: missing object model descriptor input parameter."
                    if not (mode_? and mode_) then throw "Internal error: missing mode input parameter."

                    jsonTag = ((descriptor_.namespaceType != "component") and descriptor_.jsonTag) or key_ or undefined

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
                                throw "Internal error: Unable to resolve #{descriptor_.namespaceType} namespace descriptor in bypass mode."
                            break
                        when "new"
                            if not (result.dataReference? and result.dataReference)
                                namespaceObject = {}
                                resolveActions_.initializeNamespace(namespaceObject, descriptor_.namespaceModelPropertiesDeclaration)
                                if descriptor_.namespaceType == "component"
                                    if not (resolveActions_.getUniqueKey? and resolveActions_.getUniqueKey)
                                        throw "The specified component address cannot be resolved because your Object Namespace Schema declaration does not define semantic binding function getUniqueKey."
                                    jsonTag = result.jsonTag = result.newKey = resolveActions_.getUniqueKey(namespaceObject)
                                    if not (jsonTag? and jsonTag)
                                        throw "Error obtaining a unique ID for this component."
                                result.dataReference =  data_[jsonTag] = namespaceObject
                                result.created = true
                            break
                        when "strict"
                            if not (result.dataReference? and result.dataReference)
                                throw "Internal error: Unable to resolve  #{descriptor_.namespaceType} namespace descriptor in strict mode."
                            resolveActions_.verifyNamespace(result.dataReference, descriptor_.namespaceModelPropertiesDeclaration)
                            break
                        else
                            throw "Unrecognized mode parameter value."

                    return result

                catch exception
                    throw "ONMjs.implementatin.AddressTokenBinder.localResolveNamespaceDescriptor failure: #{exception}"


            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------

            @store = store_? and store_ or throw "Missing object store input parameter."
            model = store_.model
            @parentDataReference = parentDataReference_? and parentDataReference_ or throw "Missing parent data reference input parameter."
            if not (token_? and token_) then throw "Missing object model address token object input parameter."
            if not (mode_? and mode_) then throw "Missing mode input parameter."
            @dataReference = undefined
            @dataReferenceAsComponentRoot = dataReferenceAsComponentRoot_? and dataReferenceAsComponentRoot_ or false

            @resolvedToken = token_.clone()

            targetNamespaceDescriptor = token_.namespaceDescriptor
            targetComponentDescriptor = token_.componentDescriptor

            semanticBindings = model.getSemanticBindings()
            getUniqueKeyFunction = semanticBindings? and semanticBindings and semanticBindings.getUniqueKey? and semanticBindings.getUniqueKey or undefined


            resolveActions = {
                initializeNamespace: localInitializeNamespaceMembers
                verifyNamespace: localVerifyNamespaceMembers
                getUniqueKey: getUniqueKeyFunction
            }

            resolveResult = {}
            if not @dataReferenceAsComponentRoot

                resolveResult = localResolveNamespaceDescriptor(resolveActions, store_, @parentDataReference, targetComponentDescriptor, token_.key, mode_)

                extensionPointId = token_.extensionPointDescriptor? and token_.extensionPointDescriptor and token_.extensionPointDescriptor.id or -1

                if mode_ == "new" and resolveResult.created
                    localInitializeComponent(store_, resolveResult.dataReference, targetComponentDescriptor, extensionPointId)

                if mode_ == "strict"
                    localVerifyComponent(store_, resolveResult.dataReference, targetComponentDescriptor, extensionPointId)            

                if targetNamespaceDescriptor.isComponent
                    if resolveResult.newKey? and resolveResult.newKey then @resolvedToken.key = resolveResult.newKey
                    @dataReference = resolveResult.dataReference
                    return
            else
                resolveResult.dataReference = @parentDataReference

            # Resolve the target namespace relative to its component root.
            targetNamespaceHeightOverComponent = targetNamespaceDescriptor.parentPathIdVector.length - targetComponentDescriptor.parentPathIdVector.length - 1
            pathIdsToProcess = targetNamespaceHeightOverComponent and targetNamespaceDescriptor.parentPathIdVector.slice(-targetNamespaceHeightOverComponent) or []

            for pathId in pathIdsToProcess
                descriptor = model.getNamespaceDescriptorFromPathId(pathId)
                resolveResult = localResolveNamespaceDescriptor(resolveActions, store_, resolveResult.dataReference, descriptor, undefined, mode_)
            resolveResult = localResolveNamespaceDescriptor(resolveActions, store_, resolveResult.dataReference, targetNamespaceDescriptor, undefined, mode_)
            @dataReference = resolveResult.dataReference
            return

            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------
            # ----------------------------------------------------------------------------

        catch exception
            throw "ONMjs.implementation.AddressTokenBinder failure: #{exception}"


