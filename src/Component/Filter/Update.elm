module Component.Filter.Update (Action(..), Addresses, update) where
{-| Our API for a filtering component
@docs Action, Addresses, update
-}

import Effects exposing (Effects)
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

{-| we demand that we get an addresses record with an entry for our filter called "filter"
this allows us to compose other addresses together and yet only have a single
atom at the top level
-}
type alias Addresses a =
  { a
  | filter : Signal.Address Action
  }

{-| Takes the addresses record, the action, and the model
Runs the defined action on the model
-}
update : Addresses a -> Action -> Model b c -> (Model b c, Effects.Effects Action)
update addresses action model =
  case action of
    NoOp ->
      (model, Effects.none)

    SetFilterDisabled name state ->
      let
        filters =
          updateFiltersByName name (\filter -> { filter | isDisabled = state }) model.filters
      in
        ( { model | filters = filters }, Effects.none)

    SetFilterChecked name state ->
      let
        filters =
          updateFiltersByName name (\filter -> { filter | isChecked = state }) model.filters
      in
        ( { model | filters = filters }, Effects.none)

    SetFilterVisible name state ->
      let
        filters =
          updateFiltersByName name (\filter -> { filter | isVisible = state }) model.filters
      in
        ( { model | filters = filters }, Effects.none)


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

