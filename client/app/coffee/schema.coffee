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
Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}

Encapsule.runtime.backchannel = Encapsule.runtime.backchannel? and Encapsule.runtime.backchannel or @Encapsule.runtime.backchannel = new Encapsule.code.lib.base.BackChannel();
backchannel = Encapsule.runtime.backchannel

Encapsule.runtime.boot = {
    onBootstrapComplete: (bootstrapperStatus_) ->
        backchannel.log("Application on bootstrap complete.");
        Encapsule.runtime.app.schema = new Encapsule.code.app.Schema()
    }

$ ->
    try
        Encapsule.code.app.bootstrapper.run Encapsule.runtime.boot
        backchannel.log("Application booted successfully.")
    catch exception
        backchannel.error("Application boot failure: #{exception}")
    @




