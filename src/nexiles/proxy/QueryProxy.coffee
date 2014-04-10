Ext.define "Nexiles.proxy.QueryProxy",
    extend: "Ext.data.proxy.Ajax"
    alias:  "proxy.query"

    reader:
        type: "json"
        noCache: no
        root: "items"
        totalProperty: "total_count"

    buildRequest: (operation) ->
        console.debug "QueryProxy::buildRequest"

        request = @callParent arguments

        # we count from ZERO dammit
        request.params.page -= 1

        console.debug "QueryProxy::buildRequest url=#{request.url} page=#{request.params.page} start=#{request.params.start} limit=#{request.params.limit}"
        return request




