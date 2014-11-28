class Person
    constructor: (@firstname) ->
    walk: ->
        alert "#{@firstname} walking"
        true

class Student extends Person
    constructor: (firstname, @subject) ->
        super firstname

    walk: ->
        alert "#{@firstname} walking, studying #{@subject}"
        true

    getName: ->
        alert "#{@firstname}"
        true

    setName: (name) -> 
        @firstname = name
        true

p = new Person "XYZ"
do p.walk

s = new Student "Abc", "Maths"
do s.getName
s.setName "New"
do s.walk
