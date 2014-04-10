Ext.define "Nexiles.widgets.StatusBar",
    extend: "Ext.ux.statusbar.StatusBar"

    xtype: "nx-statusbar"
    alias: "widget.nx-statusbar"

    version_loaders: [
        url: "resources/version.json"
        tpl: "{name} v{version} - build {build} - date {date}"
    ]

    make_item: (options) ->
        xtype: "component"
        tpl: options?.tpl or "{name} v{version} - build {build} date {date}"
        cls: "x-toolbar-text"
        data:
            name: "?"
            version: "?"
            build: "?"
            date: "?"
        loader:
            url: options?.url or "resources/version.json"
            renderer: "data"
            autoLoad: yes

    make_items: (configs)->
        items = []

        for option in configs
            items.push "-"
            items.push @make_item option

        items.push "copyright &copy; #{new Date().getFullYear()} - <a href='http://www.nexiles.de' target='_blank'>nexiles GmbH</a>"
        return items

    initComponent: ->
        console.debug "*** Nexiles.widgets.StatusBar::initComponent"

        Ext.applyIf @,
            defaultText: 'Default status text'
            defaultIconCls: 'default-icon'
            text: 'Ready'
            iconCls: 'ready-icon'

            items: @make_items @version_loaders


        @callParent arguments

# vim: set ft=coffee ts=4 sw=4 expandtab :

