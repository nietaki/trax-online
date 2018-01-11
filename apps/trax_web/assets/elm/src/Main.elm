module Main exposing (..)

import Array exposing (Array)
import Html


-- CONSTANTS


colCount : Int
colCount =
    8


rowCount : Int
rowCount =
    8


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type FieldState
    = On
    | Off


type alias BoardState =
    Array (Array FieldState)


type alias Model =
    BoardState


init : ( Model, Cmd Msg )
init =
    let
        emptyRow =
            Array.repeat colCount Off

        rows =
            Array.repeat rowCount emptyRow
    in
        ( rows, Cmd.none )


type Msg
    = Foo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Foo ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view model =
    -- Html.text "hello from normal program"
    boardView model


fieldView : FieldState -> Html.Html msg
fieldView fieldState =
    Html.td [] [ Html.text (fieldText fieldState) ]


rowView : Array FieldState -> Html.Html msg
rowView rowState =
    Html.tr [] (Array.toList (Array.map fieldView rowState))


boardView boardState =
    Html.table [] (Array.toList (Array.map rowView boardState))


fieldText fieldState =
    case fieldState of
        On ->
            "on"

        Off ->
            "off"
