module Component.Filter.API exposing (..) -- where

import Html exposing (div, Html)
import Html.App as Html

import Component.Filter.Update as FilterUpdate
import Component.Filter.Model as FilterModel
import Component.Filter.View as FilterView


--- toplevel/Update.Elm
import Component.Text.Update as TextUpdate

-- toplevel/Model.elm
import Component.Text.Model as TextModel

-- toplevel/View.elm
import Component.Text.View as TextView

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
        , { name = "another test"
        , isDisabled = False
        , isChecked = True
        , isVisible = True
        , value = "robot"
        , text = "another test"
        , type' = "robot"
        }
    ]

main : Program Never
main =
    let
        initModel : TopLevelModel
        initModel =
            { robot =
                { inputText = "robot" }
            , cat =
                { inputText = "cat" }
            , filters = defaultFilters
            }

        modelWithEffects =
            (initModel, Cmd.none)
    in
        Html.program
            { init = modelWithEffects
            , view = view
            , update = router
            , subscriptions = (\_ -> Sub.none)
            }


type alias TextEntries =
    { robot : TextModel.Model {}
    , cat : TextModel.Model {}
    }

type TextEntry = Robot | Cat

type alias TopLevelModel =
    FilterModel.Model TextEntries String

type TopLevelAction =
    Run | Hide

type MessageRouter
    = TopLevel TopLevelAction
    | FilterLevel FilterUpdate.Action
    | TextLevel TextEntry TextUpdate.Action


topLevelUpdate : TopLevelAction -> TopLevelModel -> (TopLevelModel, Cmd TopLevelAction)
topLevelUpdate action model =
    (model, Cmd.none)


router : MessageRouter -> TopLevelModel -> (TopLevelModel, Cmd MessageRouter)
router message model =
    case message of
        TopLevel action ->
            let
                (newModel, commands) =
                    topLevelUpdate action model
            in
                (newModel, Cmd.map TopLevel commands)

        FilterLevel action ->
            let
                _ =
                    Debug.log "FilterLevelAction" action
                (newModel, commands) =
                    FilterUpdate.update action model
            in
                (newModel, Cmd.map FilterLevel commands)

        TextLevel field action ->
            let
                (newField, commands) =
                    TextUpdate.update action (get field model)
            in
                (set field model newField, Cmd.map (TextLevel field) action)

view : TopLevelModel -> Html MessageRouter
view model =
    div
        []
        [ Html.map FilterLevel (FilterView.view model)
        , Html.map (TextLevel (.cat)) (TextView.view model.cat)
        , Html.map (TextLevel (.robot)) (TextView.view model.robot)

        ]


