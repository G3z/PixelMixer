class ZoomOut extends PMTool
    constructor:(pixMix)->
        args = {
            action:"zoomOut"
        }
        super("-",pixMix.layers,args)
