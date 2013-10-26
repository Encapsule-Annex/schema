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
                console? and console and console.log? and console.log and console.log("ONMjsDataModelHost:: #{message_}") or false

            bcError = (message_) ->
                message = 
                console? and console and console.error? and console.error and console.error("ONMjsDataModelHost:: #{message_}") or false

            @backchannel = new Encapsule.code.lib.base.BackChannel(bcLog, bcError)
            @backchannelModelView = new ONMjs.observers.BackchannelView(@backchannel)

            @observers =
                path:      new ONMjs.observers.SelectedPathModelView(@backchannel)
                navigator: new ONMjs.observers.NavigatorModelView(@backchannel)
                namespace: new ONMjs.observers.SelectedNamespaceModelView(@backchannel)
                json:      new ONMjs.observers.SelectedJsonModelView(@backchannel)

            @model = undefined
            @store = undefined
            @addressStore = undefined
            @observerId1 = undefined
            @observerId2 = undefined

            @attachObservers = =>
                try
                    if @observerId1? and @observerId1
                        throw "Observers are already attached."
                    @observerId1 = @store.registerObserver(@addressStore.objectStoreCallbacks, @addressStore)
                    @observers.path.attachToCachedAddress(@addressStore)
                    @observers.navigator.attachToStore(@store)
                    @observerId2 = @observers.navigator.attachToCachedAddress(@addressStore)
                    @observers.navigator.setCachedAddressSink(@addressStore)
                    @observers.namespace.attachToCachedAddress(@addressStore)
                    @observers.json.attachToCachedAddress(@addressStore)
                    true
                catch exception
                    throw "Encapsule.app.lib.ONMjsDataModelHost.attachObservers failure: #{exception}"


            @detachObservers = =>
                try
                    if not (@observerId1? and @observerId1)
                        return false

                    errors = 0
                    try
                        @observers.json.detachFromCachedAddress()
                    catch exception
                        errors++
                        @backchannel.error(exception)
                    try
                        @observers.namespace.detachFromCachedAddress()
                    catch exception
                        errors++
                        @backchannel.error(exception)
                    try
                        @observers.navigator.setCachedAddressSink(undefined)
                    catch exception
                        errors++
                        @backchannel.error(exception)
                    try
                        @observers.navigator.detachFromCachedAddress(@addressStore, @observerId2)
                    catch exception
                        errors++
                        @backchannel.error(exception)
                    try
                        @observers.navigator.detachFromStore()
                    catch exception
                        errors++
                        @backchannel.error(exception)
                    try
                        @observers.path.detachFromCachedAddress()
                    catch exception
                        errors++
                        @backchannel.error(exception)
                    try
                        @store.unregisterObserver(@observerId1)
                    catch exception
                        errors++
                        @backchannel.error(exception)

                    @observerId1 = @observerId2 = undefined
                    if errors
                        throw "#{errors} occurred during detach observers attempt."
                    true
                catch exception
                    throw "Encapsule.app.lib.ONMjsDataModelHost.detachObservers failure: #{exception}"


            @updateModel = (store_, address_, dataModelDeclaration_) =>
                try
                    @detachObservers()
                    if not (dataModelDeclaration_? and dataModelDeclaration_)
                        @model = undefined
                        @store = undefined
                        @addressStore = undefined
                        @status = "offline"
                        @backchannel.clearLog()
                        @backchannel.log("<h1>offline</h1>")
                        return true
                    @backchannel.clearLog()
                    @backchannel.log("<h1>ONMjs boot</h1>")
                    @backchannel.log("ONMjs data model declaration object has been updated.")
                    @backchannel.log("... creating ONMjs.Model class instance...")
                    @model = new ONMjs.Model(dataModelDeclaration_)
                    @backchannel.log("... creating ONMjs.Store class instance...")
                    @store = new ONMjs.Store(@model)
                    @backchannel.log("... creating ONMjs.AddressStore class instance...")
                    @addressStore = new ONMjs.AddressStore(@store, @model.createRootAddress())
                    @backchannel.log("... attaching generic observers to new runtime data...")
                    @attachObservers()
                    @backchannel.log("<h1>ONMjs online</h1>")
                    @backchannel.log("data model '#{dataModelDeclaration_.jsonTag}' is online.")

                catch exception
                    @backchannel.error("ONMjsDataModelHost failure: #{exception}")



        catch exception
            throw "Encapsule.app.lib.ONMjsDataModelHost failure: #{exception}"