module Main exposing (..)

import Dict exposing (Dict)
import Game exposing (..)
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
    Game


init : ( Model, Cmd Msg )
init =
    ( newGame, Cmd.none )


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
                ( boardAction (cycleTile coords) model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text <| (++) "current player: " <| toString model.currentPlayer
        , Html.br [] []
        , Html.text <| (++) "current move: " <| toString model.currentMove
        , gameView model
        ]


gameView : Game -> Html.Html Msg
gameView game =
    let
        rowIndices =
            List.range 0 (rowCount - 1)

        colIndices =
            List.range 0 (colCount - 1)

        indices =
            cartesian rowIndices colIndices
    in
        Html.table [] (List.map (rowView game) indices)


rowView : Game -> List Coords -> Html.Html Msg
rowView game row =
    Html.tr [] (List.map (fieldView game) row)


fieldView : Game -> Coords -> Html.Html Msg
fieldView game coords =
    case game.currentMove of
        Nothing ->
            tileView (Dict.get coords game.board) (Click coords)

        Just move ->
            if move.coords == coords then
                tileView (Just move.tile) (Click coords)
                -- TODO fix the Msg
            else
                tileView (Dict.get coords game.board) (Click coords)


tileView : Maybe Tile -> Msg -> Html.Html Msg
tileView maybeTile onClickMessage =
    let
        ( sideClass, rotationClass ) =
            case maybeTile of
                Nothing ->
                    ( "", "0" )

                Just { side, rotation } ->
                    ( toString side, toString rotation )

        tileClass =
            String.toLower ("tile " ++ sideClass ++ " rotate" ++ rotationClass)
    in
        Html.td [ onClick <| onClickMessage, Attributes.class tileClass ] [ Html.text (toString onClickMessage) ]
