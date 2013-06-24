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
# encapsule-lib-omm-object-store-namespace-binder.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.implementation = Encapsule.code.lib.omm.implementation? and Encapsule.code.lib.omm.implementation or @Encapsule.code.lib.omm.implementation = {}




#
# ****************************************************************************
#
# An ObjectStoreNamespaceBinder class instance is a helper object responsible for 
# locating specific sub-objects within an OMM store.
#
# ObjectStore, the parent class by containment, maintains an array of ObjectStoreNamespaceBinder
# instances per object model path ID ordinal.
#
# At runtime, an app may obtain a reference to a specific object (or sub-object) within an ObjectStore
# by calling the bindNamespace method. bindNamespace takes as input ObjectModelNamespaceSelector and
# returns a reference to the sub-object data.
#
# Internally ObjectStore.bindNamespace delegates to ObjectStoreNamespaceBinder.bind.
#

class Encapsule.code.lib.omm.ObjectStoreNamespaceBinder
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
    constructor: (objectStore_, objectModelDescriptor_) ->
        # ==============================================================================
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter!"
            if not (objectModelDescriptor_? and objectModelDescriptor_) then throw "Missing object model descriptor input parameter."

            # Keep references to this namespace's backing store.
            @objectStore = objectStore_
            @objectModelDescriptor = objectModelDescriptor_

            @keysRequiredToBind = objectModelDescriptor_.pathResolveExtensionPoints.length

            # If successful, bind returns to the caller a new instance of ObjectStoreNamespace that represents
            # a specific sub-object in the OM instance owned by ObjectStore. The specific sub-object to bind
            # is specified by OM coordinates specified in the objectModelNamespaceSelector_ parameter. If the
            # the coordinates specified in the namespace selector cannot be resolved, bind throws an exception.
            #
            # ==============================================================================
            # \ BEGIN: bind
            @bind = (objectModelNamespaceSelector_, bindMode_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_) then throw "Missing object model namespace selector input parameter!"

                    bindMode = "new"
                    if bindMode_? and bindMode_ and bindMode_ == "strict"
                        bindMode = "strict"

                    # ------------------------------------------------------------------------------
                    # \ BEGIN: internalBindNamespace
                    internalBindNamespace = (objectModelDescriptor_, objectStoreReference_) =>

                        storeReference = undefined

                        switch objectModelDescriptor_.mvvmType
                            when "root"
                                storeReference = @objectStore.objectStore
                                break

                            when "child"
                                storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                                if not (storeReference? and storeReference)
                                    if bindMode == "new"
                                        objectStoreReference_[objectModelDescriptor_.jsonTag] = {}
                                        storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                                    else
                                        throw "Strict mode binding failure: child namespace does not exist for \"#{objectModelDescriptor_.jsonTag}\"."
                                break

                            when "extension"
                                storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                                if not (storeReference? and storeReference)
                                    objectStoreReference_[objectModelDescriptor_.jsonTag] = []
                                    storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                                break

                            when "archetype"
                                extensionPointSelectIndex++
                                extensionPointSelectKey = objectModelNamespaceSelector_.getSelectKey(extensionPointSelectIndex_)
                                elementFound = false
                                for elementObject in objectStoreReference_
                                    # Should hey "hey - is this your key?"
                                    if elementObject.uuid? and elementObject.uuid
                                        if elementObject.uuid == extensionPointSelectKey
                                            elementFound = true
                                            break
                                if not elementFound
                                    throw "Extension bind failure for path #{parentObjectModelDescriptor.path}: cannot resolve extension point key \"#{extensionPointSelectKey}\"."
                                storeReference = elementObject
                                break

                            else
                                throw "Unrecognized mvvmType \"#{parentObjectModelDescriptor.mvvmType}\"!"

                        if not (storeReference? and storeReference)
                            throw "Cannot resolve store reference!"

                        return storeReference
                    # / END: internalBindNamespace
                    # ------------------------------------------------------------------------------

                    # Bind the indicated namespace's parent namespaces.

                    objectModel = @objectStore.objectModel # alias

                    extensionPointSelectIndex = -1
                    objectStoreReference = undefined

                    for parentPathId in @objectModelDescriptor.parentPathIdVector
                        parentObjectModelDescriptor = objectModel.objectModelDescriptorById[parentPathId]
                        objectStoreReference = internalBindNamespace(parentObjectModelDescriptor, objectStoreReference)

                    # Bind this namespace
                    objectStoreReference = internalBindNamespace(@objectModelDescriptor, objectStoreReference)

                    newStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_, objectStoreReference)
                    return newStoreNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStoreNamespace.bind failed: #{exception}"

            # / END: bind
            # ==============================================================================

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespaceBinder constructor failed: #{exception}"

        # ==============================================================================
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
# ****************************************************************************
