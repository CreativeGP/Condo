import structure
import strutils, tables, options

proc eval(stmt: Stmt, superfn: Fn): Option[seq[Base]]
proc go*(fn: Fn, args: seq[Base]): Option[seq[Base]]
proc resolveStmt(stmt: var Stmt)
proc resolveName(s: string): Fn

var fnstack: seq[Fn] = @[]

proc debug*(fn: Fn) =
  echo fn.binds


# Name -> Fn
proc resolveName(s: string): Fn =
  for fn in fnstack:
    return fn.binds[s]

# Iterate through statement expanding tokens according to the binding table
proc resolveStmt(stmt: var Stmt) =
  for i in 0..<stmt.len:
    if stmt[i].checkStmt == "Token":
      var tkn = unwrapToken(stmt[i])
      if tkn.ty == ttName:
        stmt[i] = wrapFn(resolveName(tkn.val))


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

# proc embedArgument(stmt: var Stmt, args: seq[Base], argnames: seq[string]) =
#   for i in 0 .. <stmt.len:
#     case stmt[i].checkStmt:
#       of "Token":
#         var tkn = unwrapToken(stmt[i])
#         var idx = argnames.find(tkn.val)
#         if tkn.ty == ttName && idx != -1:
#           stmt.delete(i, 1)
#           stmt.delete(i, args[

# Eval a statement
proc eval(stmt: Stmt, superfn: Fn): Option[seq[Base]] =
  if stmt.len == 0: return
  
  let semicolon = stmt[^1].checkStmt == "Token" and unwrapToken(stmt[^1]).val == ";"
  let stmt_end_idx = (if semicolon: stmt.len-2 else: stmt.len-1)
  var fn: Fn
  case stmt[0].checkStmt:
    of "Token":
      var tkn = unwrapToken(stmt[0])
      # TODO Diagnostics

      # Build-in functions (debug)
      if tkn.val == "let":
        var name = unwrapToken(stmt[1]).val
        var fn = newFn()
        var new_stmt = Stmt(stmt[2 .. stmt_end_idx])
        resolveStmt new_stmt
        fn.body.add new_stmt
        superfn.binds.add(name, fn)
        return
      elif tkn.val == "echo":
        echo Stmt(stmt[1 .. stmt_end_idx])
        return
        
      fn = resolveName(tkn.val)
    of "Fn":
      fn = unwrapFn(stmt[0])

  var res = go(fn, stmt[1 .. stmt_end_idx])
  return if semicolon: none(seq[Base]) else: res


# Run through a function and return a statement
# (NOTE All "value" in this language can at least be represented as a stmt <- redundant?)
proc go*(fn: Fn, args: seq[Base]): Option[seq[Base]] =
  var res: Option[seq[Base]] = none(seq[Base])
  fnstack.add fn
  # TODO Arguments local binding
  for stmt in fn.body:
    var e = eval(stmt, fn)
    if e.isSome: res = e

  fnstack.delete(fnstack.len-1)
  return res
