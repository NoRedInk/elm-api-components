module Dom (find, findInNode, DomNode, htmlToString) where

import Native.Dom
import Html exposing (Html)

type DomNode =
    DomNode

{-| Convert a Html node to a string
-}
htmlToString : Html -> String
htmlToString node =
    Native.Dom.htmlToString node

{-| Search the given Html for any valid query selector
-}
find : String -> Html -> List DomNode
find query html =
    htmlToString html
        |> stringToCheerio
        |> Native.Dom.find query

{-| look inside a dom node for something
-}
findInNode : String -> DomNode -> List DomNode
findInNode query node =
    Native.Dom.find query node

{-| convert html to a domnode
-}
stringToCheerio : String -> DomNode
stringToCheerio html =
    Native.Dom.stringToCheerio html
