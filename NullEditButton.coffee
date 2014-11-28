jQuery.fn.extend

    color: (options) ->

        # Default settings
        settings =
            debug: false

            Oasis: $("a[data-id='history']").closest("ul")
            Monobook: $("#ca-edit").parent()
            
            ShowTime: 3000
            HideTime: 1400

            messages:
                en:
                    text: "Null Edit"
                    tooltip: "Null Edit this page"
                    success: "Null Edit successful!"
                    failed: "Null Edit failed!"
            
                es:
                    text: "Edición vacía"
                    tooltip: "Editar esta página sin hacer cambios"
                    success: "Edición vacía exitosa!"
                    failed: "Edición vacía fallado"
            
                pl:
                    text: "Pusta edycja"
                    tooltip: "Pusta edycja na tej stronie"
                    success: "Pusta edycja  sukces!"
                    failed: "Pusta edycja zawiodly!"
            
                sv:
                    text: "Tom redigera"
                    tooltip: "Tom redigera denna sid"
                    success: "Tom redigera framgångsrik!"
                    failed: "Tom redigera misslyckades!"

        messages = $.extend messages.en, messages[mw.config.get("wgContentLanguage")], messages[mw.config.get("wgUserLanguage")], options.messages
        settings = $.extend settings, options

        addButton = ->
            $button = $("<li><a/>").find("a").attr(
                href: "#"
                accesskey: "0"
                id: "ca-null-edit"
                title: messages.title
            ).text(messages.text).click(edit).end()
            $sel = if mw.config.get("skin") is "oasis" then $("a[data-id='history']").closest("ul") else $("#ca-edit").parent()
            $sel.append $button

        # Show results
        showResult = (message, result) ->
            if mw.config.get("skin") is "oasis"
                window.GlobalNotification.show message, result
            else
                window.alert message

        # Get the page
        getPage = ->
            $("#ca-null-edit").html "<img id=\"null-edit-throbber\" src=\"" + mw.config.get("stylepath") + "/common/images/ajax.gif\" /> Getting page..."
            $cc.load window.location.href + " #mw-content-text > *", ->
                $("#ca-null-edit").parent().remove()
                addButton()

                # Fix collapsibles, sortables and tabber
                $cc.find(".mw-collapsible").makeCollapsible()
                $cc.find("table.sortable").tablesorter()    if $cc.find("table.sortable").length
                tabberAutomaticOnLoad()    if $cc.find(".tabber").length

                # Allow users to add custom callback functions if needed
                neCallAgain = window.NullEditCallAgain or []
                neCallAgain.forEach (v) ->
                    v()

                # Fade-in the page slowly
                $cc.fadeToggle 3000
                
                # Success notification
                showResult messages.success, "confirm"
                return
        
            return
        onError = ->
            $("#ca-null-edit").parent().remove()
            addButton()
            $cc.fadeIn()
            showResult messages.failed, "error"
            return
        
        # Ajax edit the page
        edit = (e) ->
            $cc.fadeToggle 1400
            e.preventDefault()
            $("#ca-null-edit").html "<img id=\"null-edit-throbber\" src=\"" + mw.config.get("stylepath") + "/common/images/ajax.gif\" /> Editing..."
            new mw.Api().post(
                format: "json"
                action: "edit"
                title: mw.config.get("wgPageName")
                token: mw.user.tokens.get("editToken")
                prependtext: ""
            ).done(->
                getPage()
                return
            ).fail ->
                onError()
                return
        
            return
        
        # Init
        $ ->
            addButton()    if not $("#ca-null-edit").length and $("#ca-edit, a[data-id='editprofile'], a[data-id='leavemessage']").length
            return

        # Simple logger.
        log = (msg) ->
        console?.log msg if settings.debug

        # _Insert magic here._
        @.each ->
            @.css("color", settings.color)
