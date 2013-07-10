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
# schema-view-model-svg-plane.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


class Encapsule.code.app.SchemaViewModelSvgPlane
    constructor: ->

        @initializeD3 = =>
            try

                # data = [ 5, 20, 18, 17, 3, 19, 65 ]




                objectModel = Encapsule.runtime.app.SchemaObjectModel

                @data = objectModel.objectModelDescriptorById


                svg = d3.select("#idSchemaSVGHost").append("svg").attr("width", "100%").attr("height", "100%")

                rectangles = svg.selectAll("rect").
                    data(@data).
                    enter().
                    append("rect").
                    style("fill", "#00CCFF").
                    attr("width", 64).
                    attr("height", 1).
                    attr("x", (d,i) -> 32 + (d.parentPathIdVector.length * 16)).
                    attr("y", (d,i) -> 32 + (i * 16) )

                circles = 
                    svg.selectAll("circle").
                    data(@data).
                    enter().
                    append("circle").
                    style("fill", (d, i) -> 
                        switch d.mvvmType
                            when "root"
                                return "red"
                            when "child"
                                return "red"
                            when "extension"
                                return "yellow"
                            when "archetype"
                                return "green"
                            ).
                    attr("r", 4).
                    attr("cx", (d, i) -> 32 + (d.parentPathIdVector.length * 16)).
                    attr("cy", (d, i) -> 32 + (i * 16) )


                labels = svg.selectAll("text").
                    data(@data).
                    enter().
                    append("text").
                    text( (d,i) -> return "#{d.label}" ).
                    attr("x", (d,i) -> 96 + (d.parentPathIdVector.length * 16)).
                    attr("y", (d,i) -> 36 + (i * 16)).
                    attr("fill", "black")



            catch exception
                throw "Encapsule.code.app.SchemaViewModelSvgPlane.initializeD3 failure: #{exception}"




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelSvgPlane", ( ->
    """
    <div id="idSchemaSVGHost" style="width: 100%; height: 100%;"></div>
    """))
