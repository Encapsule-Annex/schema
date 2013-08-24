###

  The MIT License (MIT)
  
  Copyright (c) 2013 Christopher D. Russell, Encapsule Project
  
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

  ----------------------------------------------------------------------------

  encapsule-lib-omm-core-address-token.js


  ----------------------------------------------------------------------------

  >>>> Encapsule Project :: Build better software with circuit models.

  Please support the Encapsule Project, free and open software, and the quest
  to build a better world where information and the software that is required
  to make sense of it are open, free, and accessible to everyone.

  http://encapsule.org * https://twitter.com/Encapsule * https://github.com/Encapsule

###
#
#
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

            @idExtensionPoint = idExtensionPoint_? and idExtensionPoint_ or -1
            @extensionPointDescriptor = undefined

            @idComponent = 0
            @componentDescriptor = undefined

            if not idNamespace_? then throw "Missing target namespace ID input parameter."
            @idNamespace = idNamespace_
            @namespaceDescriptor = model_.getNamespaceDescriptorFromPathId(idNamespace_)

            @idComponent = @namespaceDescriptor.idComponent
            @componentDescriptor = @namespaceDescriptor.isComponent and @namespaceDescriptor or @model.getNamespaceDescriptorFromPathId(@idComponent)

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

            if @idExtensionPoint == -1

                if not @componentDescriptor.extensionPointReferenceIds.length
                    # We can auto-resolve the extension point ID because for this component
                    # there are no cyclic references defined and thus the mapping of component
                    # to extension point ID's is 1:1 (child to parent respectively).
                    @idExtensionPoint = @componentDescriptor.parent.id
                else
                    # This component is a valid extension of more than one extension point.
                    # Thus we must have the ID of the parent extension point in order to disambiguate.
                    throw "You must specify the ID of the parent extension point when creating a token addressing a '#{@componentDescriptor.path}' component namespace."

            @extensionPointDescriptor = model_.getNamespaceDescriptorFromPathId(@idExtensionPoint)

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
