module Main exposing (..)

import Board exposing (..)
import Dict exposing (Dict)
import Helpers exposing (..)


-- import Helpers exposing (..)

import Html
import Html.Attributes as Attributes
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    Board


init : ( Model, Cmd Msg )
init =
    ( Dict.empty, Cmd.none )


type Msg
    = Click Coords


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        whatever =
            Debug.log "incoming message" msg
    in
        case msg of
            Click coords ->
                ( placeTile coords model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view model =
    boardView model


boardView : Board -> Html.Html Msg
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


rowView : Board -> List Coords -> Html.Html Msg
rowView boardState row =
    Html.tr [] (List.map (fieldView boardState) row)


fieldView : Board -> Coords -> Html.Html Msg
fieldView boardState coords =
    let
        ( sideClass, rotationClass ) =
            case Dict.get coords boardState of
                Nothing ->
                    ( "", "0" )

                Just { side, rotation } ->
                    ( "straight", toString rotation )

        tileClass =
            "tile " ++ sideClass ++ " rotate" ++ rotationClass
    in
        Html.td [ onClick <| Click coords, Attributes.class tileClass ] [ Html.text (fieldText boardState coords) ]


fieldText : Board -> Coords -> String
fieldText boardState coords =
    (toString coords) ++ ":  "
