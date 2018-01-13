module Helpers exposing (..)

import Dict exposing (Dict)
import Maybe exposing (Maybe)


cartesian : List a -> List b -> List (List ( a, b ))
cartesian xs ys =
    let
        tuplize a ls =
            List.map (makeTuple a) ls
    in
        List.map (\x -> tuplize x ys) xs


makeTuple : a -> b -> ( a, b )
makeTuple a b =
    ( a, b )


getWithDefault : comparable -> Dict comparable a -> a -> a
getWithDefault key dictionary default =
    case Dict.get key dictionary of
        Nothing ->
            default

        Just a ->
            a
