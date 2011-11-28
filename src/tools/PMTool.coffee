class PMTool
    @options = {}
    constructor:(icon,target,arg={action:"setActive",args:this})->
        @button = new PMButton(38,38,icon,target,arg)

    leftClick:()=>

    rightClick:()=>