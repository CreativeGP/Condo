import lex, structure

var file : File = open("test/ex1.co", fmRead)
var source = file.readAll.string
var tokens: seq[Token] = tokenize(source)
#var root: Fn = parse(tokens)
echo tokens
