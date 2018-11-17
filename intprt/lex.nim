import sequtils
import sets


# Type sould be a set of entities which it abstructs.
# However I use strings denoting sets becuase the size of set
# may be infinity (e.g. int)
# 
# TODO: The basic set operation function is used to create new type.
# However, for infinite types, special (internal) implementaion must be needed.
# I must think about how to create type and deal with infinite types.
type
  NaturalType = string
  Type = HashSet[NaturalType]
  TypeAnnotation = seq[Type]

# TODO: Token type. Utilize pointers.
type
  Token = string
  Stmt = seq[Token]
  Fn = ref object
    ty : TypeAnnotation
    body : seq[Stmt]
    args : seq[Fn]


const Specials = "!#$%&()-^\\@[;:],./=~|`{+*}<>?"
const Escapes = "\"'"
const Split = " \t\n"
const EscapeModePadding = 100
    

proc ctos(ch : char) : string =
  var res = newString(1)
  res[0] = ch
  return res

proc addToken(tokens : var seq[Token], value : string) =
  if value == "": return
  tokens.add value

proc tokenize*(code : string) : seq[Token] =
  var tokens : seq[Token] = @[]
  var little = ""
  var mode = 0
  
  for i in 0 .. <code.len:
    if mode == 0:
      if Split.contains(code[i]):
        tokens.addToken little
        little = ""
        continue

      if Escapes.contains(code[i]):
        mode = EscapeModePadding + (Escapes.find code[i])
        tokens.addToken(code[i].ctos)
        continue

      if Specials.contains(code[i]):
        tokens.addToken little
        little = ""
        tokens.add(code[i].ctos)
      else: little.add code[i]
    else:
      var escape_chr = Escapes[mode - EscapeModePadding]
      try:
        if (code[i-2] == '\\' or code[i-1] != '\\') and code[i] == escape_chr:
          tokens.addToken little
          tokens.add(escape_chr.ctos)
          mode = 0
          little = ""
        else: little.add code[i]
      except IndexError: little.add code[i]
      
  return tokens
