module Component.Filter.Update exposing (Action(..), update) -- where
{-| Our API for a filtering component
@docs Action, update
-}

import Component.Filter.Model exposing (..)

{-| The actions defined here can be considered our external API
The top level component will be able to trigger these actions,
as well as the local component
-}
type Action
  = NoOp
  | SetFilterDisabled String Bool
  | SetFilterChecked String Bool
  | SetFilterVisible String Bool


{-| Takes the addresses record, the action, and the model
Runs the defined action on the model
-}
update : Action -> Model b c -> (Model b c, Cmd Action)
update action model =
  case action of
    NoOp ->
      (model, Cmd.none)

    SetFilterDisabled name state ->
      let
        filters =
          updateFiltersByName name (\filter -> { filter | isDisabled = state }) model.filters
      in
        ( { model | filters = filters }, Cmd.none)

    SetFilterChecked name state ->
      let
        filters =
          updateFiltersByName name (\filter -> { filter | isChecked = state }) model.filters
      in
        ( { model | filters = filters }, Cmd.none)

    SetFilterVisible name state ->
      let
        filters =
          updateFiltersByName name (\filter -> { filter | isVisible = state }) model.filters
      in
        ( { model | filters = filters }, Cmd.none)


{-| Update the filters with the given name with the given update function
-}
updateFiltersByName : String -> (FilterField a -> FilterField a) -> List (FilterField a) -> List (FilterField a)
updateFiltersByName name updater fields =
  fields
    |> List.map (\filter ->
        if filter.name == name then
          updater filter
        else
          filter
      )

