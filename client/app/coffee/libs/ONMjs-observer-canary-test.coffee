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

Canary is a test observer that observes a ONMjs.Store and sings to the console logger.

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
ONMjs.test = {}
ONMjs.test.observers = {}

class ONMjs.test.observers.Canary
    constructor: ->

    callbackInterface: {

        onObserverAttachBegin: (store_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onObserverAttachBegin")

        onObserverAttachEnd: (store_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onObserverAttachEnd")

        onObserverDetachBegin: (store_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onObserverDetachBegin")

        onObserverDetachEnd: (store_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onObserverDetachEnd")

        onComponentCreated: (store_, address_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onComponentCreated")

        onComponentRemoved: (store_, address_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onComponentRemoved")

        onNamespaceCreated: (store_, address_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onNamespaceCreated")

        onNamespaceUpdated: (store_, address_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onNamespaceUpdated")

        onComponentUpdated: (store_, address_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onComponentUpdated")

        onNamespaceRemoved: (store_, address_, observerId_) =>
            Console.message("ONMjs.test.observers.Canary.callbackInterface.onNamespaceRemoved")


    }       
