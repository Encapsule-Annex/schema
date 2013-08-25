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
                    jsonTag: "addressSelectorselector"
                    label: "#{referenceStore_.objectModel.jsonTag} Address Selector"
                    description: "#{referenceStore_.objectModel.label} address selector"
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

                onNamespaceUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                    try
                        selector = @getSelector()
                        if selector.getHashString() == namespaceSelector_.getHashString()
                            # TODO:
                            # This is _convenient_ as it automatically hits observers
                            # with a callback when the currently selected store namespace
                            # is modified. But this is actually sort of wrong...
                            # We really don't want the selector involved in this detail because
                            # it's the business of whoever is doing the observing to decide
                            # what they want to watch. It's far better to foist the additional
                            # complexity on observers than to OR the two disjoint concepts
                            # together (and provide no way to discriminate between the two
                            # cases). Simle fix.
                            #

                            # GOING TO TAKE THIS FIX WHILE RE-WORKING THIS CLASS FOR ADDRESS SUPPORT.
                            # WILL BE TEARING ALL THE OBSERVERS APART ANYWAY...

                            # POSSIBLE.
                            @setSelector(@getSelector())
                    catch exception
                        throw "Encapsule.code.lib.omm.SelectorStore.objectStoreCallbacks.onNamespaceUpdated failure: #{exception}"

                onChildNamespaceUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                    try
                        selector = @getSelector()
                        if selector.getHashString() == namespaceSelector_.getHashString()
                            # TODO: same as above
                            # !!!! NO NO NO - WE DON'T WANT TO DO THIS. SEE COMMENTS ABOVE.
                            @setSelector(@getSelector())
                    catch exception
                        throw "Encapsule.code.lib.omm.SelectorStore.objectStoreCallbacks.onChildNamespaceUpdated failure: #{exception}"

                # onParentNamespaceUpdated: (objectStore_, observerId_, namespaceSelector_) =>

                onNamespaceRemoved: (objectStore_, observerId_, namespaceSelector_) =>
                    try
                        currentSelector = @getSelector()
                        if currentSelector.getHashString() == namespaceSelector_.getHashString()
                            parentId = currentSelector.objectModelDescriptor.parent.id
                            parentSelector = currentSelector.createParentSelector()
                            # !!! AUDIT THIS BUT WITHOUT LOOKING IT SEEMS LIKE IT'S THE RIGHT THING?
                            @setSelector(parentSelector)
                        return
                    catch exception
                        throw "Encapsule.code.lib.omm.CachedAddress.objectStoreCallbacks.onNamespaceRemoved failure: #{exception}"

            }


        catch exception
            throw "Encapsule.code.lib.omm.CachedAddress failure: #{exception}"


    #
    # ============================================================================
    getAddress: =>
        try
            return @selectorNamespaceData.selectedNamespace? and @selectorNamespaceData.selectedNamespace and @selectedNamespaceData.selectedNamespace.address() or undefined
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

