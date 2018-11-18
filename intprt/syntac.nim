import iter, tables, structure

proc statement(tokens : var iter[Token]) : Stmt
proc function(tokens : var iter[Token]) : Fn
proc parse*(tokens : var seq[Token]) : Stmt

proc argument(tokens: var iter[Token]): seq[Token] =
  var args: seq[Token] = @[]
  if *tokens == "|":
    # parse arguments
    inc tokens # pass |
    for t in tokens.itr:
      args.add *tokens
      inc tokens
      if *tokens == "|": break
    inc tokens
    return args

proc function(tokens: var iter[Token]): Fn =
  var fn: Fn
  new fn
  
  inc tokens # pass (
  fn.args = argument(tokens)
  for t in tokens.itr:
    fn.body.add statement(tokens)
    case *tokens:
      of ")": return fn
      else: discard


proc statement(tokens: var iter[Token]): Stmt =
  var stmt: Stmt = @[]
  for t in tokens.itr:
    case *tokens:
      of ";",")":
        inc tokens
        return stmt
      of "(":
        stmt.add function(tokens)
      else: discard
    stmt.add *tokens
  return stmt


proc parse*(tokens: var seq[Token]): Fn =
  var seqitr = Iter(tokens.addr, 0)
  return function(seqitr)
