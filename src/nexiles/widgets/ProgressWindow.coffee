Ext.define "Nexiles.widgets.ProgressWindow",
    extend: "Ext.window.Window"
    xtype:  "progresswindow"

    alias:  "widget.progresswindow"

    requires: [
        "Ext.ProgressBar"
    ]

    closable: no
    resizable: no

    bodyPadding: 10

    initComponent: ->
        console.log "*** ProgressWindow::initComponent"

        @progressbar_text ?= "Please wait ..."

        @long_text ?= """
        <p>Please wait while the operation is in progress.</p>
        <br/>
        """

        @progress = Ext.widget "progressbar",
            animate: yes
            text: @progressbar_text

        Ext.applyIf @,
            width:   400
            height:  120

            items: [
                xtype: "component"
                html:  @long_text
            ,
                @progress
            ]

        @callParent arguments

