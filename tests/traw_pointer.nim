import std/[unittest]
import ptr_math

suite "raw pointer math":
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
      p = cast[pointer](addr(a[0]))

  test "incr ptr":
    p = p + (1*sizeof(MyObject))
    check cast[ptr MyObject](p)[0].i == 300

  test "decr ptr":
    p = cast[pointer](addr(a[2]))
    p = p - (1*sizeof(MyObject))
    check cast[ptr MyObject](p)[0].f == 4.5

  test "inplace incr ptr":
    p += (2*sizeof(MyObject))
    check cast[ptr MyObject](p)[0].i == 500
    cast[ptr MyObject](p)[0].f = 7.89
    check a[2].f == 7.89

  test "inplace decr ptr":
    p = addr(a[2])
    p -= (1*sizeof(MyObject))
    check cast[ptr MyObject](p)[-1].i == 100
    cast[ptr MyObject](p)[1].f = 456.789
    check a[2] == MyObject(i: 500, f: 456.789, b: true)
