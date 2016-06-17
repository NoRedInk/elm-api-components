module Component.Filter.API exposing (..) -- where

import Html.App exposing (program)
import Html exposing (Html)

import Nri.Colors

import Component.Filter.Update exposing (update, Action(..))
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

main : Program Never
main =
    let
        initModel : Model {} String
        initModel =
            { filters = defaultFilters }

        modelWithEffects =
            (initModel, Cmd.none)
    in
        program
            { init = modelWithEffects
            , view = view
            , update = update
            , subscriptions = \_ -> Sub.none
            }
