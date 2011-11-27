###
    Main PixelMixer Class
###

#import

#@codekit-prepend PMEditableImage.coffee
#@codekit-prepend PMPixel.coffee
#@codekit-prepend PMCanvas.coffee
#@codekit-prepend PMLayers.coffee
#@codekit-prepend PMWindow.coffee

class PixelMixer
    ###
        main Configuration
        attr {
            scope: "page" |  "#containerIds" | ".containerClass"
            container: "containerId" | floating
            width: xxx
            height: yyy
            zoom: true | false
            onload: true | false
        }
    ###
    @scope
    @container
    @width
    @height
    @zoom
    @layers
    @imgs
    constructor:(attr)->
        @isMouseDown=false
        @zoom = 1
        if attr?
            if $.type(attr) == "object"
                if attr.scope? && $.type(attr.scope)=="string"
                    if attr.scope.substr(0,1) == "#" or attr.scope.substr(0,1) == "."
                        scope = attr.scope + " img"
                        @scope = $(scope)
                    else if attr.scope == "page"
                        @scope = $("img")
                else
                    @scope = $("img")
                if attr.onload? && $.type(attr.onload) == "boolean"
                    @onload = attr.onload
                else
                    @onload = true
                if attr.container?
                    @container = $(attr.container)
                    @container.attr("width","500")
                    @container.attr("height","500")
                    @container.css("position","relative")
        else
            @scope = $("img")
            @onload = true
        @imgs = new Array()
        if @onload?
            $(window).load(
                ()=>
                    @prepareImgs(@scope)
            )
        else
            @prepareImgs(@scope)
        
        @loaderElm = document.createElement("canvas")
        @loaderElm.setAttribute("width",@container.attr("width"))
        @loaderElm.setAttribute("height",@container.attr("height"))
        @loader = @loaderElm.getContext("2d")

        @layers = new PMLayers(@container,this)
        @layers.add()

        @container.bind("mousemove",
            (event)=>
                @mouseOver(event)
        )
        @container.bind("mousedown",
            (event)=>
                @mouseDown(event)
        )
        @container.bind("mouseup",
            (event)=>
                @mouseUp(event)
        )

    mouseOver:(evt)=>
        @container[0].style.cursor='crosshair'
        if @isMouseDown
            pixel = @pixelAtPoint(@eventToPoint(evt))
            if pixel?
                pixel.darken(20)
                @update(pixel)
    
    mouseDown:(evt)=>
        @container[0].style.cursor='crosshair'
        @isMouseDown = true
        pixel = @pixelAtPoint(@eventToPoint(evt))
        if pixel?
            pixel.darken(20)
            @update(pixel)
    mouseUp:(evt)=>
        @isMouseDown = false

    eventToPoint:( event )=>
        point = {
            x: event.pageX - @container.offset().left
            y: event.pageY - @container.offset().top
        }

    loadImg:(img)=>

        @layers.l0.load(img,@loader)

    prepareImgs:(scope)=>
        scope.each(
            (i,img)=>
                @makeEditable(img)
        )

    makeEditable:(img)=>
        imageEdit = new PMEditableImage(img,this)
        @imgs.push imageEdit if imageEdit?

