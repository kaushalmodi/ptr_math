import std/[unittest]
import ptr_math

suite "iterators":
  setup:
    type
      MyObject = object
        i: int
        f: float
        b: bool

    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = addr(a[0])

  test "items ptr, from start excluding end":
    var pend = p + a.len
    var i = 0
    for it in items(p, pend):
      check it.i == a[i].i
      inc i
  
  test "mitems ptr, from start excluding end":
    var pend = p + a.len
    for it in mitems(p, pend):
      inc it.i
    check a[2].i == 501

  test "items UncheckedArray[T] | ptr T with length":
    var i = 0
    for it in items(p, a.len):
      check it.i == a[i].i
      inc i

    i = 0
    for it in items(p, a.len.uint): # test unsigned length
      check it.i == a[i].i
      inc i

    var u = cast[ptr UncheckedArray[MyObject]](a[0].addr)
    i = 0
    for it in items(u[], a.len):
      check it.i == a[i].i
      inc i
  
 
  test "mitems UncheckedArray with length":
    var u = cast[ptr UncheckedArray[MyObject]](a[0].addr)
    for it in mitems(u[], a.len):
      inc it.i
    check a[2].i == 501

    for it in mitems(u[], a.len.uint):
      inc it.i
    check a[2].i == 502

  test "mitems ptr with length":
    for it in mitems(p, a.len):
      inc it.i
    check a[2].i == 501

    for it in mitems(p, a.len.uint):
      inc it.i
    check a[2].i == 502
  
  test "pairs UncheckedArray[T] | ptr T with len":
    for i, it in pairs(p, a.len):
      check it.i == a[i].i

    for i, it in pairs(p, a.len.uint): # test unsigned length
      check it.i == a[i].i

    var u = cast[ptr UncheckedArray[MyObject]](a[0].addr)
    for i, it in pairs(u[], a.len):
      check it.i == a[i].i

  test "mpairs UncheckedArray with length":
    var u = cast[ptr UncheckedArray[MyObject]](a[0].addr)
    for i, it in mpairs(u[], a.len):
      check a[i] == it

    for i, it in mpairs(u[], a.len.uint):
      check a[i] == it

  test "mpairs ptr with length":
    for i, it in mpairs(p, a.len):
      check a[i] == it

    for i, it in mpairs(p, a.len.uint):
      check a[i] == it