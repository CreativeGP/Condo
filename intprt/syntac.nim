import sets, iter

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

proc statement(tokens : var iter[Token]) : Stmt =
  var stmt : Stmt = @[]
  try:
    for t in tokens.itr:
      if *tokens == ";": return stmt
      stmt.add(*tokens)
  except IndexError:
    return stmt

# proc function(tokens : var iter[Token]) : Fn =
#   var fn : Fn
#   inc(tokens) # pass (
#   try:
#     fn.add(statement(tokens))
#     if *tokens == ")"
#   except IndexError:
#     return stmt


# proc parse*(tokens : var seq[Token]) : seq[Fn] =
  
