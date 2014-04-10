Ext.define "Nexiles.widgets.FilterToolbar",
    extend: "Ext.toolbar.Toolbar"

    xtype: "filtertoolbar"
    alias: "widget.filtertoolbar"

    initComponent: ->
        console.debug "*** Nexiles.widgets.FilterToolbar::initComponent"

        @filter_field ?= "name"
        @button_text  ?= "Löschen"
        @empty_text   ?= "filter ..."

        Ext.applyIf @,
            items: [
                xtype: "textfield"
                width: 500
                emptyText: @empty_text
                enableKeyEvents: yes
                listeners:
                    scope: @
                    keyup: @onKeyUp
                    buffer: 750
            ,
                "-"
            ,
                xtype: "button"
                text:  @button_text
                listeners:
                    scope: @
                    click: @onClearClick
            ]

        @callParent arguments


    onKeyUp: (field, e) ->
        value = field.getValue()
        store = @store
        store.clearFilter()
        if value
            store.filter @filter_field, value

    onClearClick: (btn) ->
        @store.clearFilter()
        btn.up().down("textfield").setValue("")

