# http://www.sencha.com/forum/showthread.php?132328-CLOSED-ComboBox-using-Grid-instead-of-BoundList
Ext.define "Nexiles.widgets.GridCombo",
    extend: "Ext.form.ComboBox"
    requires: [
        "Ext.grid.Panel"
    ]
    alias: "widget.nx-gridcombo"

    # copied from ComboBox
    createPicker: ->
        picker = undefined
        menuCls = Ext.baseCSSPrefix + "menu"

        opts = Ext.apply(
            selModel:
                mode: (if @multiSelect then "SIMPLE" else "SINGLE")

            floating: true
            hidden: true
            ownerCt: @ownerCt
            cls: (if @el.up("." + menuCls) then menuCls else "")
            store: @store
            displayField: @displayField
            focusOnToFront: false
            pageSize: @pageSize
        , @listConfig, @defaultListConfig)

        console.debug "GridCombo opts: ", opts

        # NOTE: we simply use a grid panel
        #picker = @picker = Ext.create('Ext.view.BoundList', opts);
        picker = @picker = Ext.create("Ext.grid.Panel", opts)
        window.grid = picker

        # hack: pass getNode() to the view
        picker.getNode = ->
            picker.getView().getNode arguments
            return

        @mon picker,
            itemclick: @onItemClick
            refresh: @onListRefresh
            scope: @

        @mon picker.getSelectionModel(),
            selectionChange: @onListSelectionChange
            scope: @

        picker

# vim: set sw=4 ts=4 expandtab:
