###
    Basic Button Class
###
class PMButton
    constructor:(@width,@height,@icon,@target,@action)->
        @domElm = $("<div/>").addClass("PMButton").addClass("blue")
        if @width? and not @height?
            @domElm.attr("style","width:#{@width}px;")
        else if not @width? and @height?
            @domElm.attr("style","height:#{@height}px;")
        else if @width? and @height?
            @domElm.attr("style","width:#{@width}px;height:#{@height}px;")
        else
            @domElm.attr("style","width:20px;height:20px;")
        if @icon?
            if @icon[-3...-4] != "."
                @domElm.html(@icon)
        @domElm.click(()=>@trigger())
            
    trigger:()=>
        if @action? and @target?
            if @action.action?
                method = @action.action
            if @action.args?
                if $.type(@action.args) == "array"
                    args = @action.args
                else
                    args = [@action.args]
        if @target? and method?
            if args?
                @target[method](args)
            else
                @target[method]()
