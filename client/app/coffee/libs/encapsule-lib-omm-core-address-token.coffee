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
# encapsule-lib-omm-core-address-token.coffee
#


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}


# ****************************************************************************
# ****************************************************************************
#
#
class Encapsule.code.lib.omm.AddressToken
    constructor: (model_, idExtensionPoint_, key_, idNamespace_) ->
        try
            @model = model_? and model_ or throw "Missing object model input parameter."
            @extensionPointDescriptor = undefined
            if not idNamespace_? then throw "Missing target namespace path ID input parameter."
            idNamespace = idNamespace_
            @namespaceDescriptor = model_.getNamespaceDescriptorFromPathId(idNamespace)
            idComponent = @namespaceDescriptor.idComponent
            @componentDescriptor = @namespaceDescriptor.isComponent and @namespaceDescriptor or model_.getNamespaceDescriptorFromPathId(idComponent)
            @key =  (@componentDescriptor.id > 0) and key_? and key_ or undefined
            @keyRequired = false


            # The namespace specified by idNamespace is contained within a component.
            # If the component ID greater than zero, then not root component.
            # If not the root component, component is child of parent extension point.
            # This means that in order to resolve the root namespace of the component
            # we require (a) the identity of the parent extension point (b) a unique
            # key for the component.

            if @componentDescriptor.id == 0
                return;

            # Parent extension point must be resolved.
            @keyRequired = true

            idExtensionPoint = idExtensionPoint_? and idExtensionPoint_ or -1

            if idExtensionPoint == -1

                if not @componentDescriptor.extensionPointReferenceIds.length
                    # We can auto-resolve the extension point ID because for this component
                    # there are no cyclic references defined and thus the mapping of component
                    # to extension point ID's is 1:1 (child to parent respectively).
                    idExtensionPoint = @componentDescriptor.parent.id
                else
                    # This component is a valid extension of more than one extension point.
                    # Thus we must have the ID of the parent extension point in order to disambiguate.
                    throw "You must specify the ID of the parent extension point when creating a token addressing a '#{@componentDescriptor.path}' component namespace."

            @extensionPointDescriptor = model_.getNamespaceDescriptorFromPathId(idExtensionPoint)

            if not (@extensionPointDescriptor? and @extensionPointDescriptor)
                throw "Internal error: unable to obtain extension point object model descriptor in request."

            if @extensionPointDescriptor.mvvmType != "extension"
                throw "Invalid selector key object specifies an invalid parent extension point ID. Not an extension point."

            if @extensionPointDescriptor.archetypePathId != @componentDescriptor.id
                throw "Invalid selector key object specifies unsupported extension point / component ID pair."

            return

        catch exception
            throw "Encapsule.code.lib.omm.AddressToken failure: #{exception}"

    #
    # ============================================================================
    clone: =>
        new Encapsule.code.lib.omm.AddressToken(
            @model
            @extensionPointDescriptor? and @extensionPointDescriptor and @extensionPointDescriptor.id or -1
            @key
            @namespaceDescriptor.id
            )

    #
    # ============================================================================
    isReady: => 
        (not @keyRequired and true) or (@key? and @key and true) or false

#
#
# ****************************************************************************
# ****************************************************************************
