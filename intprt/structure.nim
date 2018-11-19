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

  Base = ref object of RootObj
  StmtItem[T] = ref object of Base
    data: T

  # TODO: Token type. Utilize pointers.
  Token* = ref object
    val*: string
    ty*: TokenType
  
  TokenType* = enum
    ttNone
    ttSpecial
    ttName
    ttNumber
    ttString
  
  Stmt* = seq[Base]
  
  Fn* = ref object
    ty*: TypeAnnotation
    body*: seq[Stmt]
    args*: seq[Token]

proc add*(stmt: var Stmt, token: Token) =
  stmt.add(StmtItem[Token](data: token))
proc add*(stmt: var Stmt, fn: Fn) =
  stmt.add(StmtItem[Fn](data: fn))

# NOTE: Yes, this is a little redundant.
# I tried generalization, however hitted an issue(nim-lang/Nim #7469).
# proc unwrapStmt[T](item: StmtItem[T]): T =
#   try:
#     return UItem[Token](item).data
#   except ObjectConversionError:
#     return StmtItem[Fn](item).data

  
proc newFn*(): Fn =
  var fn: Fn
  new fn
  fn.ty = @[]
  fn.body = @[]
  fn.args = @[]
  return fn
# var tttable: Table[ptr Token, TokenType]
