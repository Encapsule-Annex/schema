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

class ONMjs.CachedAddress extends ONMjs.Store
    constructor: (referenceStore_, address_) ->
        try
            if not (referenceStore_? and referenceStore_) then throw "Missing object store input parameter. Unable to determine external selector type."
            @referenceStore = referenceStore_

            # Create an ObjectModel instance from the selector object model declaration.
            selectorModel = new ONMjs.Model(
                {
                    jsonTag: "cachedAddress"
                    label: "#{referenceStore_.model.jsonTag} Address Cache"
                    description: "#{referenceStore_.model.label} observable address cache."
                })

            # Initialize the base ONMjs.Store class.
            super(selectorModel)

            selectorAddress = new ONMjs.address.FromPathId(selectorModel, 0)
            @selectorNamespace = new ONMjs.Namespace(@, selectorAddress)
            @selectorNamespaceData = @selectorNamespace.data()
            @selectorNamespaceData.selectedNamespace = undefined

            # local alias
            @blipper = Encapsule.runtime.boot.phase0.blipper

            @setAddress(address_)

            @objectStoreCallbacks = {
                onNamespaceUpdated: (objectStore_, observerId_, address_) =>
                    try
                        cachedAddress = @getAddress()
                        if cachedAddress.isEqual(address_)
                            @setAddress(address_)

                    catch exception
                        throw "ONMjs.CachedAddress.objectStoreCallbacks.onNamespaceUpdated failure: #{exception}"


                onNamespaceRemoved: (objectStore_, observerId_, address_) =>
                    try
                        cachedAddress = @getAddress()
                        if cachedAddress.isEqual(address_)
                            parentAddress = ONMjs.address.Parent(cachedAddress)
                            @setAddress(parentAddress)
                        return
                    catch exception
                        throw "ONMjs.CachedAddress.objectStoreCallbacks.onNamespaceRemoved failure: #{exception}"
            } # objectStoreCallbacks


        catch exception
            throw "Encapsule.code.lib.omm.CachedAddress failure: #{exception}"


    #
    # ============================================================================
    getAddress: =>
        try
            namespace = @selectorNamespaceData.selectedNamespace
            if not (namespace? and namespace) then return undefined
            return namespace.getResolvedAddress()

        catch exception
            throw "Encapsule.code.lib.omm.CachedAddress.getSelector failure: #{exception}"


    #
    # ============================================================================
    setAddress: (address_) =>
        try
            if not (address_ and address_) 
                @selectorNamespaceData.selectedNamespace = undefined
            else
                @selectorNamespaceData.selectedNamespace = new ONMjs.Namespace(@referenceStore, address_)

            @blipper.blip("21") # double click sound
            @selectorNamespace.update()

        catch exception
            throw "Encapsule.code.lib.omm.CachedAddress.setAddress failure: #{exception}"



