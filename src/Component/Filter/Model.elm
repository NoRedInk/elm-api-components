module Component.Filter.Model exposing (Model, FilterField) -- where
{-| Our filter API

@docs Model, FilterField

-}


{-| Demand that the model has a filter property. This means you can either use
a top level model like
```
type alias Model = { filters : [] }
```
or
```
type alias Model = { filterA : { filters [] } }
```
-}
type alias Model a b =
  { a
  | filters : List (FilterField b)
  }


{-|
Each filter field has a bunch of properties useful for displaying data
-}
type alias FilterField a =
  { name : String
  , isDisabled : Bool
  , isChecked : Bool
  , isVisible : Bool
  , value : String
  , text : String
  , type' : a
  }
