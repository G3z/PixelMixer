class PMToolBar
    constructor:(@pixMix)->
        @container = @pixMix.container
        @domElm = $("<div id=\"PMToolBar\" style=\"width:40px;height:#{@container.attr('height')}px;\"></div>")
        @container.append(@domElm)
        @activeTool = null
    
    add:(button)=>
        elm = button.domElm
        @domElm.append(elm)
    
    setActiveTool:(tool)=>
        @activeTool = tool
    