class ZoomIn extends PMTool
    constructor:(pixMix)->
        args = {
            action:"add"
            args:1
        }
        super("",pixMix.zoom,args)
