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
ONMjs.observers = ONMjs.observers? and ONMjs.observers or ONMjs.observers = {}




# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************

class ONMjs.observers.SelectedNamespaceModelView
    constructor: ->
        try

            @objectStoreName = ko.observable "<not connected>"


            @title = ko.observable "<not connected>"

            @modelviewActions = ko.observable undefined
            @modelviewTitle = ko.observable undefined
            @modelviewImmutable = ko.observable undefined
            @modelviewMutable = ko.observable undefined
            @modelviewComponent = ko.observable undefined
            @modelviewChildren = ko.observable undefined
            @modelviewCollection = ko.observable undefined

            @cachedAddressStore = undefined
            @cachedAddressStoreObserverId = undefined

            #
            # ============================================================================
            @attachToCachedAddress = (cachedAddress_) =>
                try
                    if not (cachedAddress_? and cachedAddress_) then throw "Missing cached address input parameter."
                    if @cachedAddressStore? and @cachedAddressStore then throw "This namespace observer is already attached to a selected address store."
                    @cachedAddressStore = cachedAddress_
                    @cachedAddressStoreObserverId = cachedAddress_.registerObserver(@cachedAddressObserverInterface, @)
                    true
                catch exception
                    throw "ONMjs.observers.SelectedNamespaceModelView.attachToCachedAddress failure: #{exception}"

            #
            # ============================================================================
            @detachFromCachedAddress = =>
                try
                    if not (@cachedAddressStoreObserverId and @cachedAddressStoreObserverId) then throw "This namespace observer is not currently attached to a cached address store."
                    @cachedAddressStore.unregisterObserver(@cachedAddressStoreObserverId)
                    @cachedAddressStore = undefined
                    @cachedAddressStoreObserverId = undefined
                    true
                catch exception
                    throw "ONMjs.observers.SelectedNamespaceModelView.detachFromCachedAddress failure: #{exception}"

            #
            # ============================================================================
            @cachedAddressObserverInterface = {

                #
                # ----------------------------------------------------------------------------
                onComponentCreated: (cachedAddressStore_, observerId_, address_) =>
                    @cachedAddressObserverInterface.onComponentUpdated(cachedAddressStore_, observerId_, address_)

                #
                # ----------------------------------------------------------------------------
                onComponentUpdated: (cachedAddressStore_, observerId_, address_) =>

                    objectStore = cachedAddressStore_.referenceStore
                    selectedAddress = cachedAddressStore_.getAddress()

                    if not (selectedAddress and selectedAddress)
                        # The contained cached address may be undefined indicating no current seletion
                        return true

                    selectedNamespace = objectStore.openNamespace(selectedAddress)
                    selectedNamespaceModel = selectedAddress.getModel()

                    @objectStoreName = objectStore.jsonTag

                    # Gather up all the references required to construct the child model views.
                    childParams = {
                        cachedAddressStore: cachedAddressStore_
                        objectStore: objectStore
                        selectedAddress: selectedAddress
                        selectedNamespace: selectedNamespace
                        selectedNamespaceModel: selectedNamespaceModel
                    }

                    @modelviewTitle(new ONMjs.observers.SelectedNamespaceTitleModelView(childParams))
                    @modelviewActions(new ONMjs.observers.SelectedNamespaceActionsModelView(childParams))

                    namespaceType = selectedNamespaceModel.namespaceType
                    switch namespaceType
                        when "root"
                            @modelviewImmutable(new ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView(childParams))
                            @modelviewMutable(undefined)
                            newModelViewChildren = new ONMjs.observers.SelectedNamespaceChildrenModelView(childParams)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)
                            @modelviewComponent(new ONMjs.observers.SelectedNamespaceComponentModelView(childParams))
                            @modelviewCollection(undefined)
                            break
                        when "child"
                            immutableModelView = new ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView(childParams)
                            @modelviewImmutable(immutableModelView.propertyModelViews.length and immutableModelView or undefined)
                            mutableModelView = new ONMjs.observers.SelectedNamespaceMutablePropertiesModelView(childParams)
                            @modelviewMutable(mutableModelView.propertyModelViews.length and mutableModelView or undefined)
                            newModelViewChildren = new ONMjs.observers.SelectedNamespaceChildrenModelView(childParams)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)                            
                            @modelviewComponent(new ONMjs.observers.SelectedNamespaceComponentModelView(childParams))
                            @modelviewCollection(undefined)
                            break
                        when "extensionPoint"
                            @modelviewImmutable(undefined)
                            @modelviewMutable(undefined)
                            @modelviewChildren(undefined)
                            @modelviewComponent(new ONMjs.observers.SelectedNamespaceComponentModelView(childParams))
                            @modelviewCollection(new ONMjs.observers.SelectedNamespaceCollectionModelView(childParams))
                            break
                        when "component"
                            immutableModelView = new ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView(childParams)
                            @modelviewImmutable(immutableModelView.propertyModelViews.length and immutableModelView or undefined)
                            mutableModelView = new ONMjs.observers.SelectedNamespaceMutablePropertiesModelView(childParams)
                            @modelviewMutable(mutableModelView.propertyModelViews.length and mutableModelView or undefined)
                            newModelViewChildren = new ONMjs.observers.SelectedNamespaceChildrenModelView(childParams)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)
                            @modelviewComponent(new ONMjs.observers.SelectedNamespaceComponentModelView(childParams))
                            @modelviewCollection(undefined)
                            break
                        else
                            throw "Unrecognized namespace type in request."

            }


        catch exception
            throw "ONMjs.observers.SelectedNamespaceModelView construction failure: #{exception}"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceViewModel", ( -> """
<span data-bind="if: modelviewTitle"><span data-bind="with: modelviewTitle"><span data-bind="template: { name: 'idKoTemplate_SelectedNamespaceTitleViewModel' }"></span></span></span>
<span data-bind="if: modelviewActions"><span data-bind="with: modelviewActions"><span data-bind="template: { name: 'idKoTemplate_SelectedNamespaceActionsViewModel' }"></span></span></span>
<span data-bind="if: modelviewImmutable"><span data-bind="with: modelviewImmutable"><span data-bind="template: { name: 'idKoTemplate_SelectedNamespaceImmutablePropertiesViewModel' }"></span></span></span>
<span data-bind="if: modelviewMutable"><span data-bind="with: modelviewMutable"><span data-bind="template: { name: 'idKoTemplate_SelectedNamespaceMutablePropertiesViewModel'}"></span></span></span>
<span data-bind="if: modelviewCollection"><span data-bind="with: modelviewCollection"><span data-bind="template: { name: 'idKoTemplate_SelectedNamespaceCollectionViewModel'}"></span></span></span>
<span data-bind="if: modelviewComponent"><span data-bind="with: modelviewComponent"><span data-bind="template: { name: 'idKoTemplate_SelectedNamespaceComponentViewModel'}"></span></span></span>
<span data-bind="if: modelviewChildren"><span data-bind="with: modelviewChildren"><span data-bind="template: { name: 'idKoTemplate_SelectedNamespaceChildrenViewModel'}"></span></span></span>
"""))

