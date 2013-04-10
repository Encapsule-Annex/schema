###

  http://schema.encapsule.org/schema.html

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# schema-session.coffee

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}


class Encapsule.code.app.SchemaSession
    constructor: ->
        # \ BEGIN: begin constructor scope

        @installationId = uuid.v4()
        @buildId = appBuildId
        @sessionId = uuid.v4()

        Console.message("SchemaSession: install={#{@installationId}} build={#{@buildId}} session={#{@sessionId}}")

        # / END: / end constructor scope