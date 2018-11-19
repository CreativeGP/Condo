import structure
import tables

var ident_table: Table[string, Fn]


proc fn_let(name: string, value: Fn) =
  ident_table.add(name, value)


proc run(stmt: Stmt) =
  const fn_name = Token(stmt[0]).val
  case fn_name:
    of "let":
      const name = Token(stmt[1]).val
      var fn = newFn()
      fn.body = stmt[2 .. <stmt.len]
      fn_let(name, fn)
  echo ident_table


proc call*(fn: Fn) =
  for stmt in fn.body:
    run(stmt)
