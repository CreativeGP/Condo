import sets

# Type sould be a set of entities which it abstructs.
# However I use strings denoting sets becuase the size of set
# may be infinity (e.g. int)
# 
# TODO: The basic set operation function is used to create new type.
# However, for infinite types, special (internal) implementaion must be needed.
# I must think about how to create type and deal with infinite types.
type
  NaturalType* = string
  
  Type* = HashSet[NaturalType]
  
  TypeAnnotation* = seq[Type]

  Entity* = ref object of RootObj

  # TODO: Token type. Utilize pointers.
  Token* = ref object of Entity
    val*: string
    ty*: TokenType
  
  TokenType* = enum
    ttNone
    ttSpecial
    ttName
    ttNumber
    ttString
  
  Stmt* = seq[Entity]
  
  Fn* = ref object of Entity
    ty*: TypeAnnotation
    body*: seq[Stmt]
    args*: seq[Token]

proc newFn*(): Fn =
  var fn: Fn
  new fn
  fn.ty = @[]
  fn.body = @[]
  fn.args = @[]
  return fn
# var tttable: Table[ptr Token, TokenType]
