module Component.Text.Update exposing (..) -- where

import Component.Text.Model exposing (..)

type Action
  = SetInputText String
  | ClearInputText


update : Action -> Model a -> (Model a, Cmd Action)
update action model =
  case action of
    SetInputText text ->
      ( setInputText text model, Cmd.none)

    ClearInputText ->
      ( setInputText "" model, Cmd.none)


setInputText : String -> Model a -> Model a
setInputText text model =
    { model | inputText = text }
