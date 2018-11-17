import lex

var file : File = open("test/ex1.co", fmRead)
var source = file.readAll.string
echo tokenize(source)
