import structure
import strutils, tables

var ident_table = initTable[string, Fn]()

proc fn_let(name: string, value: Fn) =
  ident_table.add(name, value)

proc debug*() =
  echo ident_table

# proc eval(fn: Fn): Fn =
#   if fn.body.len == 0:
#     var tkn = unwrapToken(fn.body[0][0])
#     if tkn.ty == ttNumber:
#       return parseInt(tkn.val)
#     elif tkn.ty == ttName:
#       return eval(ident_table[tkn.val])

proc refexpand(stmt: var Stmt) =
  for i in 0..<stmt.len:
    if stmt[i].checkStmt == "Token":
      var tkn = unwrapToken(stmt[i])
      if tkn.ty == ttName:
        stmt[i] = wrapFn(ident_table[tkn.val])
  

proc run(stmt: Stmt) =
  if stmt.len == 0: return
  
  var fn_name = unwrapToken(stmt[0]).val
  case fn_name:
    of "let":
      var name = unwrapToken(stmt[1]).val
      var fn = newFn()
      var new_stmt = Stmt(stmt[2 .. <stmt.len])
      refexpand new_stmt
      fn.body.add new_stmt
      fn_let(name, fn)


proc call*(fn: Fn) =
  for stmt in fn.body:
    run(stmt)
