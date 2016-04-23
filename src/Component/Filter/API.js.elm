module Component.Filter.API where

import Html exposing (Html)
import StartApp
import Effects exposing (Never)
import Task exposing (Task)

import Nri.Colors

import Component.Filter.Update exposing (update, Action(..), Addresses)
import Component.Filter.Model exposing (Model)
import Component.Filter.View exposing (view)

defaultFilters =
    [
        { name = "a test"
        , isDisabled = False
        , isChecked = True
        , isVisible = True
        , value = "test"
        , text = "A test"
        , type' = "test"
        }
    ]

app : StartApp.App (Model {} String)
app =
    let
        initModel : Model {} String
        initModel =
            { filters = defaultFilters }

        modelWithEffects =
            (initModel, Effects.none)

        addresses =
            { filter = filterMailbox.address }
    in
        StartApp.start
            { init = modelWithEffects
            , view = view addresses
            , update = (update addresses)
            , inputs = [ ]
            }

main : Signal Html
main =
    app.html

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

filterMailbox : Signal.Mailbox Action
filterMailbox =
  Signal.mailbox NoOp
