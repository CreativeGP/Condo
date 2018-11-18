type
  iter*[T] = object
    idx : int
    adr : ptr seq[T]

proc Iter*[T](list : ptr seq[T], idx : int) : iter[T] =
  var res : iter[T]
  res.adr = list
  res.idx = idx
  return res

template `*`*[T](it : iter[T]) : T =
  it.adr[it.idx]

proc inc*[T](it : var iter[T]) =
  inc(it.idx)

iterator itr*[T](it : var iter[T]) : T =
  while it.idx < it.adr[].len:
    yield *it
    inc(it.idx)
