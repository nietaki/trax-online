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
    boardView model


fieldView row col fieldState =
    Html.td [] [ Html.text (fieldText row col fieldState) ]


rowView col rowState =
    Html.tr [] (Array.toList (Array.indexedMap (fieldView col) rowState))


boardView boardState =
    Html.table [] (Array.toList (Array.indexedMap rowView boardState))


fieldText row col fieldState =
    (toString row) ++ " " ++ (toString col) ++ " " ++ (toString fieldState)
