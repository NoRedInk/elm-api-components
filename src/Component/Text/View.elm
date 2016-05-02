module Component.Text.View exposing (..) -- where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Component.Text.Model exposing (..)
import Component.Text.Update exposing (..)


view : Model a -> Html Action
view model =
  div
    []
    [ textarea
      [ value model.inputText
      , onInput SetInputText
      ]
      []
    , button [ onClick ClearInputText] [ text "Clear text"]
    ]
