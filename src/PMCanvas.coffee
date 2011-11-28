###
    Canvas Class
###
class PMCanvas
    constructor:(@domElement,n,@pixMix)->
        unless @domElement?
            unless image?
                @canvas = $("<canvas>").attr("width",window.innerWidth/3).attr("height",window.innerHeight/3)
            else
                if image.width < window.innerWidth/2 and image.height < window.innerHeight/2
                    @canvas = $("<canvas>").attr("width",image.width ).attr("height",image.height)
        else
            @width = $(@domElement).width()
            @height = $(@domElement).height()
            @width = 500 if @width < 500
            @height = 500 if @height < 500
            @canvas = $("<canvas>").attr("width",@width).attr("height",@height)
            @canvas.css("position","absolute").css("z-index",n)
            @domElement.append(@canvas)
        @zoom = @pixMix.zoom
        @ctx = @canvas[0].getContext("2d")
        @loader = @pixMix.loader
        #@canvas.css('cursor','crosshair')

    load:(@img)=>
        if @img?
            @left = (@width - @img.width*@zoom) /2
            @top = (@height - @img.height*@zoom) /2
            @left = 0 if @left < 0
            @top = 0 if @top <0
            @ctx.fillStyle = "#fff"
            @ctx.fillRect(0,0,@width,@height)
            if @img.extension == "gif"
                @loadAnimation(@img)
            else
                @loadStill(@img)

    update:(pixel)=>
        #@pixels =[]
        if pixel?
            @ctx.fillStyle = pixel.hexColor()
            @ctx.fillRect(@left+pixel.x*@zoom,@top+pixel.y*@zoom, 1*@zoom, 1*@zoom)
        else
            @load(@img)
    
    loadStill:(@img)=>
        @loader.drawImage(@img.img,0,0)
        imgd = @loader.getImageData(0, 0, @img.width, @img.height)
        pix = imgd.data
        @pixels = []
        #console.log img.width,img.height
        x=0
        y=0
        for i in [0...pix.length] by 4
            x++
            if x > @img.width
                x = x-@img.width
                y++
            pixel = new PMPixel(pix[i],pix[i+1],pix[i+2],pix[i+3],x,y)
            #console.log pixel.hexColor()
            #debugger
            @ctx.fillStyle = pixel.hexColor()
            @ctx.fillRect(@left+x*@zoom,@top+y*@zoom, 1*@zoom, 1*@zoom)
            @pixels.push( pixel )

    loadAnimation:(img)=>
        @loadStill(img)

    pixelAtPoint:(point)=>
        if point.x > @left
            realX = Math.floor((point.x-@left)/@zoom)
        if point.y > @top
            realY = Math.floor((point.y-@top)/@zoom)
        
        if realX? and realY?
            return @pixels[(@img.width*realY+realX)-1]
            #for pixel,i in @pixels
            #    if pixel.x == realX and pixel.y == realY
            #        console.log pixel.x,pixel.y,i
            #        return pixel
                

    