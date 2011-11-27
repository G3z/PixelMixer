class PMPixel
    @red
    @green
    @blue
    @alpha
    @x
    @y
    constructor:(@red,@green,@blue,@alpha,@x,@y)->
    
    hexColor:=>
        rgb = "#"+@toHex(@red)+@toHex(@green)+@toHex(@blue)
        return rgb

    toHex:(n)=>
     n = parseInt(n,10)
     return "00" if (isNaN(n))
     n = Math.max(0,Math.min(n,255))
     return "0123456789ABCDEF".charAt((n-n%16)/16)+ "0123456789ABCDEF".charAt(n%16)
    
    darken:(amount)=>
        @red -= amount
        @green -= amount
        @blue -= amount
    
    lighten:(amount)=>
        @red += amount
        @green += amount
        @blue += amount