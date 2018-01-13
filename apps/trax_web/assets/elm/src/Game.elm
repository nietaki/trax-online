module Game exposing (..)

import Dict exposing (Dict)
import Helpers exposing (..)
import Maybe exposing (Maybe)


colCount : Int
colCount =
    8


rowCount : Int
rowCount =
    8


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
    case ( tile.side, tile.rotation ) of
        ( s, R3 ) ->
            { tile | side = otherSide s, rotation = R0 }

        ( s, r ) ->
            { tile | rotation = nextRotation r }


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


emptyBoard =
    Dict.empty


type Player
    = White
    | Red


type alias Move =
    { coords : Coords
    , tile : Tile
    }


type alias Game =
    { board : Board
    , currentPlayer : Player
    , currentMove : Maybe Move
    }


newGame : Game
newGame =
    { board = emptyBoard
    , currentPlayer = White
    , currentMove = Just { coords = ( 1, 6 ), tile = { side = Curved, rotation = R1 } }
    }


boardAction : (Board -> Board) -> Game -> Game
boardAction action game =
    { game | board = action game.board }


placeTile coords board =
    Dict.insert coords (Tile Straight R0) board


cycleTile coords board =
    case Dict.get coords board of
        Nothing ->
            placeTile coords board

        Just tile ->
            case ( tile.side, tile.rotation ) of
                ( Curved, R3 ) ->
                    Dict.remove coords board

                _ ->
                    Dict.insert coords (nextTile tile) board


removeTile coords board =
    Dict.remove coords board
