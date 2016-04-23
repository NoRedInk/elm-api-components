module Main where

import Basics exposing (..)
import Signal exposing (..)

import ElmTest exposing (..)
import Console exposing (IO, run)
import Task exposing (Task)

import FilterSpec


tests : Test
tests =
    suite "Component tests"
    [ FilterSpec.spec
    ]

console : IO ()
console = consoleRunner tests

port runner : Signal (Task.Task x ())
port runner = run console
