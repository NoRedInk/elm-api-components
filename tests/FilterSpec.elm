module FilterSpec where

import ElmTest exposing (..)

import Task
import Component.Filter.Update exposing (..)
import Component.Filter.Model exposing (..)
import Component.Filter.View exposing (..)

import Effects
import Dom
import Html exposing (Html)


quiz =
  { name = "quiz"
  , isDisabled = True
  , isChecked = True
  , isVisible = True
  , value = "quiz"
  , text = "Quizzes"
  , type' = [ 1 ]
  }

practice =
  { name = "practice"
  , isDisabled = False
  , isChecked = True
  , isVisible = True
  , value = "practice"
  , text = "Practice"
  , type' = [ 2 ]
  }

diagnostic =
  { name = "diagnostic"
  , isDisabled = False
  , isChecked = False
  , isVisible = False
  , value = "diagnostics"
  , text = "Diagnostics"
  , type' = [ 3 ]
  }

defaultModel : Model {} (List Int)
defaultModel =
  { filters =
    [ diagnostic
    , practice
    , quiz
    ]
  }

type alias Testable a =
  { a | filters : List (FilterField (List Int)) }

defaultAddresses =
  { filter = .address (Signal.mailbox NoOp) }


spec =
    suite
      "FilterSpec"
      [ testActions defaultModel runAction ]

{-| Run an action through our filter update function
-}
runAction action =
  update defaultAddresses action defaultModel

runManyActions actions defaultModel =
  List.foldl (\action model -> update defaultAddresses action model |> fst ) defaultModel actions

{-| Takes a default model and a way to run filter actions on that model
This will usually be an update function that works with the filter as a component
-}
testActions : Testable a -> (Action -> (Testable a, Effects.Effects b)) -> Test
testActions defaultModel runAction =
  let
    onlyModel = fst

    newModel =
      runManyActions
        [ SetFilterVisible quiz.name False
        , SetFilterVisible diagnostic.name True
        , SetFilterVisible diagnostic.name False
        , SetFilterVisible quiz.name True
        , SetFilterVisible quiz.name False
        , SetFilterVisible diagnostic.name True
        ]
        defaultModel
  in
    suite "FilterSpec"
      [ test "it should do nothing"
        <| assertEqual (defaultModel, Effects.none)
        <| runAction NoOp

      , test "it should set quiz to not disabled and do nothing"
        <| assertEqual
          ( { defaultModel
            | filters =
              [ diagnostic, practice, { quiz | isDisabled = False }]
            }
            , Effects.none)
        <| runAction (SetFilterDisabled quiz.name False)

      , test "it should set quiz to disabled and do nothing"
        <| assertEqual
          ( { defaultModel
            | filters =
              [ diagnostic, practice, { quiz | isDisabled = True }]
            }
            , Effects.none
          )
        <| runAction (SetFilterDisabled quiz.name True)

      , test "it should set quiz to visible and do nothing"
        <| assertEqual
          ( { defaultModel
            | filters =
              [ diagnostic, practice, { quiz | isVisible = True }]
            }
            , Effects.none
          )
        <| runAction (SetFilterVisible quiz.name True)

      , test "it should set quiz to not visible and do nothing"
        <| assertEqual
          ( { defaultModel
            | filters =
              [ diagnostic, practice, { quiz | isVisible = False }]
            }
            , Effects.none)
        <| runAction (SetFilterVisible quiz.name False)

      , test "it should set quiz to not checked and do nothing"
        <| assertEqual
          ( { defaultModel
            | filters =
              [ diagnostic, practice, { quiz | isChecked = False }]
            }
            , Effects.none)
        <| runAction (SetFilterChecked quiz.name False)

      , test "it should set quiz to checked and do nothing"
        <| assertEqual
          ( { defaultModel
            | filters =
              [ diagnostic, practice, { quiz | isChecked = True }]
            }
            , Effects.none)
        <| runAction (SetFilterChecked quiz.name True)

      , test "it should only have as many visible as those visible"
        <| assertEqual
          (List.length <| findEntries (view defaultAddresses defaultAddresses.filter defaultModel))
        <| (List.length <| List.filter (.isVisible) defaultModel.filters)

      , test "it should only have as many visible as those visible even after doing stuff"
        <| assertEqual
          (List.length <| findEntries (view defaultAddresses defaultAddresses.filter newModel))
        <| (List.length <| List.filter (.isVisible) newModel.filters)

      ]


findEntries : Html -> List Dom.DomNode
findEntries view =
  Dom.find ("." ++ filterNamespace.name ++ toString FilterEntry) view
