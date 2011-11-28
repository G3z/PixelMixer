class PMLayers
    constructor:(@container,@pixMix)->
        @length = 0
        @tools = new PMCanvas(@container,3,@pixMix)
    
    add:=>
        layer = new PMCanvas(@container,@length,@pixMix)
        @active = layer
        @["l"+@length] = layer
        @selfUpdate()

    selfUpdate:=>
        i = 0
        for prop of this
            if prop[0...1] == "l" and prop.length < 4
                i++
        @length = i

    update:=>
        i = 0
        for prop of this
            if prop[0...1] == "l" and prop.length < 4
                obj = this[prop]
                obj.zoom = @pixMix.zoom
                obj.update()
                i++
        @length = i

    zoomIn:=>
        @pixMix.zoom++
        @update()

    zoomOut:=>
        if @pixMix.zoom > 1
            @pixMix.zoom--
            @update()