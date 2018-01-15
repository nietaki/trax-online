module Main exposing (..)

import Dict exposing (Dict)
import Game exposing (..)
import Helpers exposing (..)


-- import Helpers exposing (..)

import Html
import Html.Attributes as Attributes
import Html.Events exposing (onClick)


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    Game


type alias Flags =
    { hostname : String
    , gameId : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( newGame, Cmd.none )


type Msg
    = Nop
    | TryMove Coords
    | CommitMove


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        whatever =
            Debug.log "incoming message" msg
    in
        case msg of
            TryMove coords ->
                ( tryMove coords model, Cmd.none )

            Nop ->
                ( model, Cmd.none )

            CommitMove ->
                ( commitMove model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text <| (++) "current player: " <| toString model.currentPlayer
        , Html.br [] []
        , Html.text <| (++) "current move: " <| toString model.currentMove
        , Html.br [] []
        , Html.button [ onClick CommitMove ] [ Html.text "commit the move!" ]
        , Html.br [] []
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
                -- TODO fix the fact that already placed tiles are clickable
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
        Html.td [ onClick <| onClickMessage, Attributes.class tileClass ] [ Html.text "" ]
