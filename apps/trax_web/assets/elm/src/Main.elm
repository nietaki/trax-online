module Main exposing (..)

import Dict exposing (Dict)
import Game exposing (..)
import Helpers exposing (..)


-- import Helpers exposing (..)

import Html
import Html.Attributes as Attributes
import Html.Events exposing (onClick)
import Json.Decode as JD
import WebSocket


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { flags : Flags
    , game : Game
    }


type alias Flags =
    { hostname : String
    , gameId : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model flags newGame, Cmd.none )


type Msg
    = Nop
    | TryMove Coords
    | CommitMove
    | WebSocketInput String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        whatever =
            Debug.log "incoming message" msg
    in
        case msg of
            TryMove coords ->
                ( gameApply (tryMove coords) model, Cmd.none )

            Nop ->
                ( model, Cmd.none )

            CommitMove ->
                -- ( gameApply commitMove model, WebSocket.send (websocketUrl model) (toString model) )
                ( gameApply commitMove model, WebSocket.send (websocketUrl model) "[\"make_move\", {}, {}]" )

            -- ( gameApply commitMove model, WebSocket.send (websocketUrl model) "{\"type\": \"foo\", \"data\": {}, \"metadata\": {}}" )
            WebSocketInput str ->
                ( handleWebsocketInput model str, Cmd.none )


type IncomingWebsocketMessage
    = Foo


decodeIncomingMessage : String -> Maybe IncomingWebsocketMessage
decodeIncomingMessage input =
    let
        messageType =
            JD.decodeString (JD.index 0 JD.string) input
    in
        case messageType of
            Ok "foo" ->
                Just Foo

            _ ->
                Nothing


handleWebsocketInput : Model -> String -> Model
handleWebsocketInput model input =
    let
        decodedMessage =
            decodeIncomingMessage input

        _ =
            Debug.log
                "decoded websocket messsage"
                decodedMessage
    in
        model


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen (websocketUrl model) WebSocketInput


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.text <| (++) "flags: " <| toString model.flags
        , Html.br [] []
        , Html.text <| (++) "current player: " <| toString model.game.currentPlayer
        , Html.br [] []
        , Html.text <| (++) "current move: " <| toString model.game.currentMove
        , Html.br [] []
        , Html.button [ onClick CommitMove ] [ Html.text "commit the move!" ]
        , Html.br [] []
        , gameView model.game
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



-- HELPERS


gameApply : (Game -> Game) -> Model -> Model
gameApply f model =
    { model | game = f model.game }


websocketUrl : Model -> String
websocketUrl model =
    let
        url =
            "ws://" ++ model.flags.hostname ++ ":8666/websocket/" ++ model.flags.gameId
    in
        url
