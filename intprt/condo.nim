import sequtils
import lex, syntac, structure

var file: File = open("test/ex1.co", fmRead)
var source = file.readAll.string
var tokens: seq[Token] = tokenize(source)

echo tokens.map(proc(x:Token):string = return x.val)

var root: Fn = parse(tokens)
for e in root.body:
  echo e.repr
