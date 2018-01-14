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
            { side = otherSide s, rotation = R0 }

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


nextPlayer player =
    case player of
        White ->
            Red

        Red ->
            White


type alias Move =
    { coords : Coords
    , tile : Tile
    }


type alias Game =
    { board : Board
    , currentPlayer : Player
    , currentMove : Maybe Move
    }


defaultTile : Tile
defaultTile =
    { side = Curved, rotation = R0 }


newGame : Game
newGame =
    { board = emptyBoard
    , currentPlayer = White
    , currentMove = Just { coords = ( 1, 6 ), tile = { side = Curved, rotation = R1 } }
    }


boardAction : (Board -> Board) -> Game -> Game
boardAction action game =
    { game | board = action game.board }


tryMove : Coords -> Game -> Game
tryMove coords game =
    case Dict.get coords game.board of
        Just _ ->
            -- already occupied
            game

        Nothing ->
            --
            updateCurrentMove coords game


updateCurrentMove : Coords -> Game -> Game
updateCurrentMove coords game =
    case game.currentMove of
        Nothing ->
            { game | currentMove = Just { coords = coords, tile = defaultTile } }

        Just move ->
            if move.coords == coords then
                { game | currentMove = Just { coords = coords, tile = nextTile move.tile } }
            else
                { game | currentMove = Just { coords = coords, tile = defaultTile } }
