###
    Editable Image with Overlay
###

#import
#@codekit-prepend buttons/Button.coffee

class PMEditableImage
    constructor:(@img,@pixMix)->
        unless @img?
            return false
        @extension = @img.src[-3...img.src.length].toLowerCase()
        @wrap(@img)
        @frames=[]

    wrap:(@img)=>
        #debugger
        
        @width = $(@img).width()
        @height = $(@img).height()
        #debugger
        @wrapper = $("<div/>")
        @wrapper.addClass("PMwrapper").attr("style","width:#{@width}px;height:#{@height}px;")
        @wrapper.append("<div class=\"pixMix_imageDiv\" style=\"width:#{@width}px;height:#{@height}px;\">#{ @img.outerHTML }</div>")

        @overlay = $("<div/>")
        @overlay.addClass("PMoverlay").attr("style","width:#{@width}px;height:#{@height}px;")
        @wrapper.append( @overlay )
        @overlay.hide()

        $(@wrapper).mouseenter(
            ()=>@hoverIn()
        )
        $(@wrapper).mouseleave(
            ()=>@hoverOut()
        )
        $(@wrapper).click(
            ()=>@pixMix.loadImg(this)
        )
        $(@img).replaceWith( @wrapper )
    hoverIn:()=>
        @wrapper.toggleClass("PMwrapper_selected",true)
        @overlay.fadeIn(0.6)
    
    hoverOut:(evt)=>
        @wrapper.toggleClass("PMwrapper_selected",false)
        @overlay.fadeOut(0.3)