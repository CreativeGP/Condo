import sequtils

const Specials = "!#$%&()-^\\@[;:],./=~|`{+*}<>?"
const Escapes = "\"'"
const Split = " \t\n"
const EscapeModePadding = 100

proc ctos(ch : char) : string =
  var res = newString(1)
  res[0] = ch
  return res

proc addToken(tokens : var seq[string], value : string) =
  if value == "": return
  tokens.add value

proc tokenize*(code : string) : seq[string] =
  var tokens : seq[string] = @[]
  var little = ""
  var mode = 0
  
  for i in 0..<code.len:
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
          echo escape_chr
          tokens.addToken little
          tokens.add(escape_chr.ctos)
          mode = 0
          little = ""
        else: little.add code[i]
      except IndexError: little.add code[i]
      
  return tokens
