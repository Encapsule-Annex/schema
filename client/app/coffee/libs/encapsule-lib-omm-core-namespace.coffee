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


class Encapsule.code.lib.omm.Namespace
    constructor: (objectStore_, address_, mode_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter."

            # As a matter of policy, if no address is specified or if a zero-length address is specified, open the root namespace.
            address = undefined
            if not (address_? and address_ and address_.tokenVector.length)
                objectModel = objectStore_.objectModel
                address = new Encapsule.code.lib.omm.Address(objectModel, [ new Encapsule.code.lib.omm.AddressToken(objectModel, undefined, undefined, 0) ] )
            else
                address = address_
            

            # Ensure that address and store objects were both created using the same model.
            objectModelNameStore = objectStore_.objectModel.jsonTag
            objectModelNameKeys = address.objectModel.jsonTag
            if objectModelNameStore != objectModelNameKeys
                throw "You cannot create a '#{objectModelNameStore}' store namespace with a '#{objectModelNameKeys}' select key vector."

            # Token in the address specifies a root component namespace?
            if not address.isComplete() then throw "Specified address is invalid because the first address token does not specify the object store's root component."

            mode = mode_? and mode_ or "bypass"

            if (mode != "new") and not address.isResolvable()
                throw "Specified address is unresolvable in #{mode} mode."

            # The actual store data.
            @dataReferences = []
            dataReference = objectStore_.dataReference? and objectStore_.dataReference or throw "Cannot resolve object store's root data reference."
            @dataReferences.push dataReference
            
            @addressTokenBinders = for addressToken in address.tokenVector
                tokenBinder = new Encapsule.code.lib.omm.implementation.AddressTokenBinder(objectStore_, dataReference, addressToken, mode)
                dataReference = tokenBinder.dataReference
                @dataReferences.push dataReference
                tokenBinder

        catch exception
            throw "Encapsule.code.lib.omm.Namespace failure: #{exception}"



