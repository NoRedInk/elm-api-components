module Component.Text.API exposing (..)

import Html.App as Html

import Component.Text.Update exposing (update, Action(..))
import Component.Text.Model exposing (Model)
import Component.Text.View exposing (view)


main : Program Never
main =
    let
        initModel : Model {}
        initModel =
            { inputText = "" }

        modelWithEffects =
            (initModel, Cmd.none)

    in
        Html.program
            { init = modelWithEffects
            , view = view
            , update = (update)
            , subscriptions = (\_ -> Sub.none)
            }

