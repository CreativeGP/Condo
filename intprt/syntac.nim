import iter, tables, structure

proc statement(tokens : var iter[Token]) : Stmt
proc function(tokens : var iter[Token]) : Fn
proc parse*(tokens : var seq[Token]) : Fn

  
proc argument(tokens: var iter[Token]): seq[Token] =
  var args: seq[Token] = @[]
  if (*tokens).val == "|":
    # parse arguments
    inc tokens # pass |
    for t in tokens.itr:
      if (*tokens).val == "|": break
      args.add *tokens
    inc tokens
    return args


proc statement(tokens: var iter[Token]): Stmt =
  var stmt: Stmt = @[]
  for t in tokens.itr:
    case t.val:
      of ")":
        return stmt
      of ";":
        stmt.add Token(val: ";", ty: ttSpecial)
        return stmt
      of "(":
        stmt.add function(tokens)
        continue
      else: discard
    stmt.add t
  return stmt


proc function(tokens: var iter[Token]): Fn =
  var fn = newFn()
  
  inc tokens # pass (
  fn.args = argument(tokens)
  for t in tokens.itr:
    fn.body.add statement(tokens)
    if (*tokens).val == ")": return fn

  echo "[ERROR] Funtion is not closed."


proc parse*(tokens: var seq[Token]): Fn =
  var seqitr = Iter(tokens.addr, 0)
  return function(seqitr)
