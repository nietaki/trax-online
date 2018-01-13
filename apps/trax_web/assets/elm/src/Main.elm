module Main exposing (..)

import Array exposing (Array)
import Dict exposing (Dict)
import Html
import Html.Attributes as Attributes
import Html.Events exposing (onClick)
import Maybe exposing (Maybe)


-- CONSTANTS


colCount : Int
colCount =
    8


rowCount : Int
rowCount =
    5


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias FieldState =
    Bool


type alias Coords =
    ( Int, Int )


getRow : Coords -> Int
getRow coords =
    Tuple.first coords


getCol : Coords -> Int
getCol coords =
    Tuple.second coords


type alias Sth =
    Dict Coords FieldState


type alias RowState =
    Array FieldState


type alias BoardState =
    Dict Coords FieldState


type alias Model =
    BoardState


init : ( Model, Cmd Msg )
init =
    ( Dict.empty, Cmd.none )


type Msg
    = Flip Coords


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        whatever =
            Debug.log "incoming message" msg
    in
        case msg of
            Flip coords ->
                ( flipModel coords model, Cmd.none )


flipModel : Coords -> BoardState -> BoardState
flipModel coords model =
    let
        currentFieldState =
            getWithDefault coords model False
    in
        Dict.insert coords (flipFieldState currentFieldState) model


flipFieldState : FieldState -> FieldState
flipFieldState state =
    not state


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view model =
    boardView model


boardView : BoardState -> Html.Html Msg
boardView boardState =
    let
        rowIndices =
            List.range 0 (rowCount - 1)

        colIndices =
            List.range 0 (colCount - 1)

        indices =
            cartesian rowIndices colIndices
    in
        Html.table [] (List.map (rowView boardState) indices)


rowView : BoardState -> List Coords -> Html.Html Msg
rowView boardState row =
    Html.tr [] (List.map (fieldView boardState) row)


fieldView : BoardState -> Coords -> Html.Html Msg
fieldView boardState coords =
    let
        tileType =
            if (getWithDefault coords boardState False) then
                "straight"
            else
                "curved"

        tileClass =
            "rotate1 tile " ++ tileType
    in
        Html.td [ onClick <| Flip coords, Attributes.class tileClass ] [ Html.text (fieldText boardState coords) ]


fieldText : BoardState -> Coords -> String
fieldText boardState coords =
    (toString coords) ++ " " ++ (toString (Dict.get coords boardState))



-- HELPER FUNCTIONS


arrayUpdate : Int -> (a -> a) -> Array a -> Array a
arrayUpdate index fun array =
    let
        originalElement =
            Array.get index array
    in
        case originalElement of
            Just a ->
                Array.set index (fun a) array

            Nothing ->
                array


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
