module Board exposing (..)

import Dict exposing (Dict)
import Helpers exposing (..)
import Maybe exposing (Maybe)


colCount : Int
colCount =
    8


rowCount : Int
rowCount =
    5


type TileSide
    = Straight
    | Curved


type Rotation
    = R0
    | R1
    | R2
    | R3


type alias Tile =
    { side : TileSide
    , rotation : Rotation
    }


type alias Coords =
    ( Int, Int )


getRow : Coords -> Int
getRow coords =
    Tuple.first coords


getCol : Coords -> Int
getCol coords =
    Tuple.second coords


type alias Board =
    Dict Coords Tile


placeTile coords board =
    Dict.insert coords (Tile Straight R1) board
