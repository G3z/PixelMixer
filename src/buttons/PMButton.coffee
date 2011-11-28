###
    Basic Button Class
###
class Button
    construcotr:(@width,@height,@icon,@target,@action)->
        @domElement = $("<div/>")
        if @width? and not @height?
            @domElement = $("<div/>").attr("style","width:#{@width}px;")
        else if not @width? and @height?
            @domElement = $("<div/>").attr("style","height:#{@height}px;")
        else if @width? and @height?
            @domElement = $("<div/>").attr("style","width:#{@width}px;height:#{@height}px;")
        else
            @domElement = $("<div/>").attr("style","width:20px;height:20px;")
