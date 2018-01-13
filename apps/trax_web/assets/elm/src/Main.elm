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
    = Nop
    | TryMove Coords


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        whatever =
            Debug.log "incoming message" msg
    in
        case msg of
            TryMove coords ->
                ( boardAction (cycleTile coords) model, Cmd.none )

            Nop ->
                ( model, Cmd.none )


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
            tileView (Dict.get coords game.board) (TryMove coords)

        Just move ->
            if move.coords == coords then
                tileView (Just move.tile) (TryMove coords)
                -- TODO fix the Msg
            else
                tileView (Dict.get coords game.board) (TryMove coords)


tileView : Maybe Tile -> Msg -> Html.Html Msg
tileView maybeTile onClickMessage =
    let
        ( sideClass, rotation ) =
            case maybeTile of
                Nothing ->
                    ( "", R0 )

                Just { side, rotation } ->
                    ( toString side, rotation )

        tileClass =
            String.toLower ("tile " ++ sideClass ++ " rotate" ++ (toString rotation))
    in
        Html.td [ onClick <| onClickMessage, Attributes.class tileClass ] [ Html.text (toString onClickMessage) ]
