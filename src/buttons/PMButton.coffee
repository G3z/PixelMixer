###
    Basic Button Class
###
class PMButton
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
        
        
    
    trigger:()=>
        if @action? and @target?
            if @action.action?
                method = @action.action
            if @action.args?
                if $.type(@action.args) == "array"
                    args = @action.args
                else
                    args = [@action.args]
        if @target? and method? and args?
            @target.apply(method,args)
