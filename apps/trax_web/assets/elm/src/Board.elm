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


otherSide side =
    case side of
        Straight ->
            Curved

        Curved ->
            Straight


type Rotation
    = R0
    | R1
    | R2
    | R3


nextRotation rotation =
    case rotation of
        R0 ->
            R1

        R1 ->
            R2

        R2 ->
            R3

        R3 ->
            R0


type alias Tile =
    { side : TileSide
    , rotation : Rotation
    }


nextTile : Tile -> Tile
nextTile tile =
    case tile of
        { rotation, side } ->
            { tile | rotation = nextRotation rotation }


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


cycleTile coords board =
    case Dict.get coords board of
        Nothing ->
            placeTile coords board

        Just tile ->
            Dict.insert coords (nextTile tile) board