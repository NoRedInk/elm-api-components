module Component.Filter.View (view, viewFilterCheckbox, filterNamespace, CssClasses(..)) where
{-| A view display for a filter
@docs view, viewFilterCheckbox

## Css stuff
@docs CssClasses, filterNamespace
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Signal

import Css exposing (..)
import Css.Elements as Elements
import Css.Namespace exposing (namespace)
import Html.CssHelpers exposing (withNamespace, Namespace)

import Nri.Stylers exposing (makeFont)
import Nri.Colors exposing (..)
import Component.Filter.Model exposing (..)
import Component.Filter.Update exposing (..)


{-| The CSS classes used in this view
-}
type CssClasses
  = FilterGroup
  | FilterEntry
  | Checkbox


{-| Our namespace for these filters
-}
filterNamespace : Html.CssHelpers.Namespace String a b
filterNamespace =
  withNamespace "filter"

{ css, warnings } =
  (compile << stylesheet << namespace filterNamespace.name)
    [ entryCss
    ]

entryCss : Snippet
entryCss =
  (.) FilterEntry
    [ display inlineBlock
    , paddingLeft (px 25)
    , makeFont (px 16) grayDarker
    , children
      [ Elements.label
        [ display inlineBlock
        , verticalAlign middle
        , minHeight (px 42)
        , padding2 (px 13) (px 0)
        , paddingLeft (px 35)
        , fontSize (px 16)
        , Css.property "background-position" "0px 10px, left center"
        , Css.property "background-repeat" "no-repeat"
        ]
      , Elements.input
        [ display none
        , adjacentSiblings
          [ Elements.label
            [ Css.property "background-image" "url(/assets/checkbox_unchecked.png)" ]
          ]
        ]
      , selector "input:checked + label"
        [ Css.property "background-image" "url(/assets/checkbox_checked.png)"
        , Css.property "background-position" "0px 8px, left center"
        ]
      , selector "input:indeterminate + label"
        [ Css.property "background-image" "url(/assets/checkbox_checkedPartially.png)"
        ]
      , selector "input:disabled + label"
        [ opacity (float 0.3)
        ]
      ]
    ]

{-| Displays a single filter field
-}
viewFilterCheckbox : Signal.Address Action -> FilterField a -> Html
viewFilterCheckbox address filterField =
  div
    [ filterNamespace.class [ FilterEntry ]
    ]
    [ input
      [ Html.Attributes.checked filterField.isChecked
      , Html.Attributes.disabled filterField.isDisabled
      , id filterField.name
      , name filterField.name
      , type' "checkbox"
      , value filterField.value
      , onClick address (SetFilterChecked filterField.name (not filterField.isChecked))
      ]
      []
    , label
      [ for filterField.name ]
      [ span [] [ text filterField.text ] ]
    ]

{-| Displays all filters in the model side-by-side
-}
view : Addresses a -> Signal.Address Action -> Model b c -> Html
view addresses _ model =
  let
    visibleFilters =
      List.filter (.isVisible) model.filters

  in
    div
      [ class "view-filter"
      , filterNamespace.class [ FilterGroup ]
      ]
      [ Html.CssHelpers.style css
      , div
        [ class "checkbox-container" ]
        (text "Show:" :: (List.map (viewFilterCheckbox addresses.filter) visibleFilters))
      ]
