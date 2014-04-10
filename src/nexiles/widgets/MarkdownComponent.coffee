####
# A component which is able to render markdown.
#
# Requires https://github.com/chjj/marked
#
# Markdown syntax:
# https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#wiki-tables
# https://help.github.com/articles/github-flavored-markdown

window.marked.setOptions
    gfm: true
    tables: true
    breaks: true
    pedantic: false
    sanitize: true
    smartLists: true
    smartypants: true

Ext.define "Nexiles.widgets.MarkdownComponent",
    extend: "Ext.Component"
    alias:  "widget.mdcomponent"

    isLoad: no
    autoEl:
        tag: "div"
        cls: "markdown-view"

    initComponent: ->
        console.debug "*** MarkdownComponent.initComponent"
        @callParent arguments

    onRender: ->
        console.debug "°°° MarkdownComponent.onRender", @
        @autoEl = Ext.apply {}, @initialConfig, @autoEl
        @callParent arguments

        if @url and not @isLoad
            @load()

        if @markdown
            window.marked @markdown, (err, html) =>
                throw err if err
                @el.dom.innerHTML = html


    load: ->
        console.debug "MarkdownComponent.load url=#{@url}", @

        Ext.Ajax.request
            url: @url
            success: (response) ->
                console.debug "°°° MarkdownComponent.load AJAX success", response, @
                @setMarkdown response.responseText
                @isLoad = yes
                @fireEvent "load", @
            scope: @

    setMarkdown: (md) ->
        console.debug "MarkdownComponent.setMarkdown", @
        @markdown = md
        if @rendered
            window.marked md, (err, html) =>
                throw err if err
                @el.dom.innerHTML = html

# vim: set ft=coffee ts=4 sw=4 expandtab :

