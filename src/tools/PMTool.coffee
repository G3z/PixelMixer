class PMTool
    @options = {}
    constructor:(icon,target,arg={action:"setActive",args:this})->
        @button = new PMButton(32,32,icon,target,arg)

    leftClick:()=>

    rightClick:()=>