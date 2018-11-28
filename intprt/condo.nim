import sequtils
import lex, syntac, structure, runtime, options

var file: File = open("test/ex2.co", fmRead)
var source = file.readAll.string
var tokens: seq[Token] = tokenize(source)

echo tokens.map(proc(x:Token):string = return x.val)
var root: Fn = parse(tokens)

echo root

echo get(go(root, @[]))

debug(root)
