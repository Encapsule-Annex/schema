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

Encapsule.app = Encapsule.app? and Encapsule.app or @Encapsule.app = {}
Encapsule.app.lib = Encapsule.app.lib? and Encapsule.app.lib or @Encapsule.app.lib = {}

class Encapsule.app.lib.ONMjsDataModelHost
    constructor: (parentBackchannel_) ->
        try
            @parentBackchannel = parentBackchannel_
            @status = "offline"

            bcLog = (message_) ->
                console? and console and console.log? and console.log and console.log(message_) or false

            bcError = (message_) ->
                console? and console and console.error? and console.error and console.error(message_) or false

            @backchannel = new Encapsule.code.lib.base.BackChannel(bcLog, bcError)

            @observers =
                path: new ONMjs.observers.SelectedPathModelView(@backchannel)
                navigator: new ONMjs.observers.NavigatorModelView(@backchannel)
                namespace: new ONMjs.observers.SelectedNamespaceModelView(@backchannel)
                json: new ONMjs.observers.SelectedJsonModelView(@backchannel)

            @model = undefined
            @store = undefined
            @addressStore = undefined

            @attachObservers = =>
                @backchannel.log("Detaching observers...")

            @detachObservers = =>
                @backchannel.log("Attaching observers...")

            @updateModel = (store_, address_, dataModelDeclaration_) =>
                try
                    @detachObservers()
                    if not (dataModelDeclaration_? and dataModelDeclaration_)
                        @model = undefined
                        @store = undefined
                        @addressStore = undefined
                        @status = "offline"
                        return true
                    @model = new ONMjs.Model(dataModelDeclaration_)
                    @store = new ONMjs.Store(@model)
                    @addressStore = new ONMjs.AddressStore(@store)
                    @backchannel.log("ONMjs data model host has been re-initialized with a new model declaration!")

                catch exception
                    @backchannel.error("ONMjsDataModelHost failure: #{exception}")



        catch exception
            throw "Encapsule.app.lib.ONMjsDataModelHost failure: #{exception}"