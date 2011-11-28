class ZoomIn extends PMTool
    constructor:(pixMix)->
        args = {
            action:"zoomIn"
        }
        super("+",pixMix.layers,args)
