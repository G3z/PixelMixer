class PMLayers
    constructor:(@container,@pixMix)->
        @length = 0
        @tools = new PMCanvas(@container,50,@pixMix)
    
    add:()=>
        layer = new PMCanvas(@container,@length,@pixMix)
        @["l"+@length] = layer
        @update()

    update:=>
        i = 0
        for prop of this
            if prop[0...1] == "l" and prop.length < 4
                i++
        @length = i