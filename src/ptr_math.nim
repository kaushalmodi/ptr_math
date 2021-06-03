## :Author: Kaushal Modi
## :License: MIT
##
## Introduction
## ============
## This module implements basic Pointer Arithmetic functions.
##
## Source
## ======
## `Repo link <https://github.com/kaushalmodi/ptr_math>`_
##
## The code in this module is mostly from `this code snippet <https://forum.nim-lang.org/t/1188#7366>`_ on Nim Forum.
runnableExamples:
  var
    a: array[0 .. 3, int]
    p = addr(a[0])        # p is pointing to a[0]

  for i, _ in a:
    a[i] += i

  p += 1                  # p is now pointing to a[1]
  p[] = 100               # p[] is accessing the contents of a[1]
  doAssert a[1] == 100

  p[0] = 200              # .. so does p[0]
  doAssert a[1] == 200

  p[1] -= 2               # p[1] is accessing the contents of a[2]
  doAssert a[2] == 0

  p[2] += 50              # p[2] is accessing the contents of a[3]
  doAssert a[3] == 53

  p += 2                  # p is now pointing to a[3]
  p[-1] += 77             # p[-1] is accessing the contents of a[2]
  doAssert a[2] == 77

  doAssert a == [0, 200, 77, 53]
##

proc `+`*[T](p: ptr T, offset: int): ptr T =
  ## Increments pointer `p` by `offset` that jumps memory in increments of
  ## the size of `T`.
  runnableExamples:
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
      p2 = p + 2

    doAssert p2[0].i == 500
    doAssert p2[-1].f == 4.5
  ##
  return cast[ptr T](cast[ByteAddress](p) +% (offset * sizeof(T)))
  #                                      `+%` treats x and y inputs as unsigned
  # and adds them: https://nim-lang.github.io/Nim/system.html#%2B%25%2Cint%2Cint

proc `-`*[T](p: ptr T, offset: int): ptr T =
  ## Decrements pointer `p` by `offset` that jumps memory in increments of
  ## the size of `T`.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = addr(a[2])
      p1 = p - 1
    doAssert p1[0].i == 300
    doAssert p1[-1].b == true
    doAssert p1[1].f == 6.7
  ##
  return cast[ptr T](cast[ByteAddress](p) -% (offset * sizeof(T)))

proc `+=`*[T](p: var ptr T, offset: int) =
  ## Increments pointer `p` *in place* by `offset` that jumps memory
  ## in increments of the size of `T`.
  runnableExamples:
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

    p += 1
    doAssert p[].i == 300
  ##
  p = p + offset

proc `-=`*[T](p: var ptr T, offset: int) =
  ## Decrements pointer `p` *in place* by `offset` that jumps memory
  ## in increments of the size of `T`.
  runnableExamples:
    type
      MyObject = object
        i: int
        f: float
        b: bool
    var
      a = [MyObject(i: 100, f: 2.3, b: true),
           MyObject(i: 300, f: 4.5, b: false),
           MyObject(i: 500, f: 6.7, b: true)]
      p = addr(a[2])

    p -= 2
    doAssert p[].f == 2.3
  ##
  p = p - offset

proc `[]=`*[T](p: ptr T, offset: int, val: T) =
  ## Assigns the value at memory location pointed by `p[offset]`.
  runnableExamples:
    var
      a = [1.3, -9.5, 100.0]
      p = addr(a[1])

    p[0] = 123.456
    doAssert a[1] == 123.456
  ##
  (p + offset)[] = val

proc `[]`*[T](p: ptr T, offset: int): var T =
  ## Retrieves the value from `p[offset]`.
  runnableExamples:
    var
      a = [1, 3, 5, 7]
      p = addr(a[0])

    doAssert p[] == a[0]
    doAssert p[0] == a[0]
    doAssert p[2] == a[2]
  ##
  return (p + offset)[]


when isMainModule:
  import std/[strformat]

  var
    a: array[0 .. 3, int]
    p = addr(a[0])                                # p is pointing to a[0]

  for i, _ in a:
    a[i] += i
  echo &"before                    : a = {a}"

  p += 1                                          # p is now pointing to a[1]
  p[] = 100                                       # p[] is accessing the contents of a[1]
  echo &"after p += 1; p[] = 100   : a = {a}"

  p[0] = 200                                      # .. so does p[0]
  echo &"after p[0] = 200          : a = {a}"

  p[1] -= 2                                       # p[1] is accessing the contents of a[2]
  echo &"after p[1] -= 2           : a = {a}"

  p[2] += 50                                      # p[2] is accessing the contents of a[3]
  echo &"after p[2] += 50          : a = {a}"

  p += 2                                          # p is now pointing to a[3]
  p[-1] += 77                                     # p[-1] is accessing the contents of a[2]
  echo &"after p += 2; p[-1] += 77 : a = {a}"

  echo &"a[0] = p[-3] = {p[-3]}"
  echo &"a[1] = p[-2] = {p[-2]}"
  echo &"a[2] = p[-1] = {p[-1]}"
  echo &"a[3] = p[0] = {p[0]}"

  doAssert a == [0, 200, 77, 53]
