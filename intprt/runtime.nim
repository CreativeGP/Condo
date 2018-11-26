import structure
import strutils, tables, options

proc eval(stmt: Stmt): Option[seq[Base]]
proc go*(fn: Fn, args: seq[Base]): Option[seq[Base]]


var ident_table = initTable[string, Fn]()

proc fn_let(name: string, value: Fn) =
  ident_table.add(name, value)

proc debug*() =
  echo ident_table


proc refexpand(stmt: var Stmt) =
  for i in 0..<stmt.len:
    if stmt[i].checkStmt == "Token":
      var tkn = unwrapToken(stmt[i])
      if tkn.ty == ttName:
        stmt[i] = wrapFn(ident_table[tkn.val])


# proc run(stmt: Stmt) =
#   if stmt.len == 0: return
  
#   var fn_name = unwrapToken(stmt[0]).val
#   case fn_name:
#     of "let":
#       var name = unwrapToken(stmt[1]).val
#       var fn = newFn()
#       var new_stmt = Stmt(stmt[2 .. <stmt.len])
#       refexpand new_stmt
#       fn.body.add new_stmt
#       fn_let(name, fn)

proc eval(stmt: Stmt): Option[seq[Base]] =
  var fn: Fn
  case stmt[0].checkStmt:
    of "Token":
      var tkn = unwrapToken(stmt[0])
      # TODO Diagnostics
      fn = ident_table[tkn.val]
    of "Fn":
      fn = unwrapFn(stmt[0])

  return go(fn, stmt[1 .. <stmt.len])

# Run through a function and return a statement
# (NOTE All "value" in this language can at least be represented as a stmt <- redundant?)
proc go*(fn: Fn, args: seq[Base]): Option[seq[Base]] =
  var res: Option[seq[Base]] = none(seq[Base])
  # TODO Arguments local binding
  for stmt in fn.body:
    var e = eval(stmt)
    if e.isSome: res = e
  return res
