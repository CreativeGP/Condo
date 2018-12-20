import sets, tables

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

  Base* = ref object of RootObj
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
    binds*: Table[string, Fn]

proc checkStmt*(item: Base): string
proc `$`*(stmt: Stmt): string
proc `$`*(fn: Fn): string
proc add*(stmt: var Stmt, token: Token)
proc add*(stmt: var Stmt, fn: Fn)

proc parseTypeAnnotation(stmt: Stmt): TypeAnnotation =
  var res = @[]
  for i in 0..<stmt.len:
    if unwrapToken(stmt[i]).val == "-":
    res.add(stmt[i])


proc add*(stmt: var Stmt, token: Token) =
  stmt.add(StmtItem[Token](data: token))
proc add*(stmt: var Stmt, fn: Fn) =
  stmt.add(StmtItem[Fn](data: fn))

# NOTE: Yes, this is a little redundant.
# I tried generalization, however hitted an issue(nim-lang/Nim #7469).
# proc unwrapStmt(item: Base): typed =
#   try:
#     return StmtItem[Token](item).data
#   except ObjectConversionError:
#     return StmtItem[Fn](item).data

# TODO: Generalization?
proc unwrapToken*(item: Base): Token =
  return StmtItem[Token](item).data
proc unwrapFn*(item: Base): Fn =
  return StmtItem[Fn](item).data
proc wrapToken*(token: Token): Base =
  return StmtItem[Token](data:token)
proc wrapFn*(fn: Fn): Base =
  return StmtItem[Fn](data:fn)

proc checkStmt*(item: Base): string =
  try:
    var tmp = StmtItem[Token](item).data
    return "Token"
  except ObjectConversionError:
    return "Fn"
    
proc `$`*(stmt: Stmt): string =
  result = ""
  for item in stmt:
    case checkStmt(item):
      of "Token":
        result &= unwrapToken(item).val & " "
      of "Fn":
        result &= `$` unwrapFn(item)
      else:
        echo "[ERROR] Invalid type in statement"
  result &= "\n"

proc `$`*(fn: Fn): string =
  result = "Fn["
  for t in fn.args:
    result &= " " & t.val
  result &= "] (\n"
  for stmt in fn.body:
    result &= `$` stmt
  result &= ")\n\n"

  
proc newFn*(): Fn =
  var fn: Fn
  new fn
  fn.ty = @[]
  fn.body = @[]
  fn.args = @[]
  fn.binds = initTable[string, Fn]()
  return fn
# var tttable: Table[ptr Token, TokenType]
