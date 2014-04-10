Ext.define "Nexiles.store.QueryStore",
    extend:   "Ext.data.Store"
    storeId:  "querystore"
    requires: [
        "Nexiles.proxy.QueryProxy"
    ]

    base_url: "/Windchill/servlet/nexiles/tools/services/query/1.0/query"

    query_url: (session) ->
        "#{@base_url}/#{session}"

    pageSize: 25

    proxy:
        noCache: no
        type: "query"
        url:  "dummy"


    set_query: (query, callback) ->
        console.debug "QueryStore::set_query ", query
        @query = query

    open: (callback) ->
        console.debug "QueryStore::open"
        if @session_id
            throw "QueryStore::open: already open with session #{@session_id}"

        callback ?= ->

        console.time "QueryStore::open"

        Ext.Ajax.request
            url: "#{@base_url}?limit=#{@pageSize}"
            method: "POST"
            scope: @
            jsonData: @query
            callback: (options, success, response) ->
                console.timeEnd "QueryStore::open"
                if not success
                    console.error "QueryStore::open server response: ", response.status
                    throw "QueryStore::open: server response #{response.status}"

                data = Ext.JSON.decode response.responseText
                console.debug "QueryStore::open POST RESULT:", data

                if data.success
                    @session_id = data.session
                    @fireEvent "open", data.session
                    callback @session_id, data


    close: (callback) ->
        console.debug "QueryStore::close"

        if @session_id is undefined
            throw "QueryStore::close no session yet"

        if @session_id == 0
            return

        callback ?= ->

        console.time "QueryStore::close"

        Ext.Ajax.request
            url: @query_url @session_id
            method: "DELETE"
            scope: @
            callback: (options, success, response) ->
                console.timeEnd "QueryStore::close"
                if not success
                    console.error "QueryStore::close server response: ", response.status
                    throw "QueryStore::close: server response #{response.status}"

                data = Ext.JSON.decode response.responseText
                console.debug "QueryStore::close DELETE RESULT:", data

                if data.success
                    session_id = @session_id
                    @session_id = undefined
                    @fireEvent "close", session_id
                    callback session_id

    listeners:
        open: (session) ->
            console.debug "QueryStore::open session=#{session}"

        close: (session) ->
            console.debug "QueryStore::close session=#{session}"

        firstload: (operation) ->
            console.debug "QueryStore::firstload"

            @loading = yes

            # open session
            @open (session_id, data) =>
                @loadRawData data
                @totalCount = data.total_count
                @loading = no
                @fireEvent "load", @, @data.items, yes

        beforeload: (store, operation, opts) ->
            console.debug "QueryStore::beforeload page=#{operation.page} limit=#{operation.limit}"

            if not @session_id?
                @fireEvent "firstload",
                    operation: operation

                return no #  stop default load impl

            if @session_id == 0
                # session id 0 means we got everything in th eopen call already.
                return no

            store.proxy.url = store.query_url @session_id
            return yes


    constructor: (config) ->
        console.debug "QueryStore::constructor config=", config
        @callParent arguments

        if config.query
            @set_query config.query

# vim: set ft=coffee ts=4 sw=4 expandtab :


