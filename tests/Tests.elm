module Tests (..) where

import ElmTest exposing (..)
import FilterSpec


all : Test
all =
  suite
    "Component tests"
    [ FilterSpec.spec
    ]
