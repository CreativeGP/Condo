import structure
import tables

var ident_table = initTable[string, Fn]()


proc fn_let(name: string, value: Fn) =
  ident_table.add(name, value)


proc run(stmt: Stmt) =
  if stmt.len == 0: return
  
  var fn_name = unwrapToken(stmt[0]).val
  case fn_name:
    of "let":
      var name = unwrapToken(stmt[1]).val
      var fn = newFn()
      fn.body.add Stmt(stmt[2 .. <stmt.len])
      fn_let(name, fn)
  echo ident_table


proc call*(fn: Fn) =
  for stmt in fn.body:
    run(stmt)
