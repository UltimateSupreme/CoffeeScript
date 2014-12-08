class Row
    constructor:(@name, @title)->
        @id = "id-#{name}"
    html:->
         '<tr>\n' +
         '<td class="mw-label"><label style= "cursor: help;" for="' + @id + '" title="' + @title + '">' + @name + ':</label></td>\n' +
         '</tr>\n';
    jquerify:->
        $ @html()

class checkedRow extends Row
    constructor:(name, title, @regex)-> super(name, title)
    check:-> $(@id).val() is ""

a = ''
a += new Row("Decr", "Enter  Des").html()
a += new Row("Source", "Ent sour").html()
a += new Row("Blah", "Ente Bla").html()

$("#mw-content-text").append a
Checky = new checkedRow "Checked", "Ent Check"
Checky.check()
