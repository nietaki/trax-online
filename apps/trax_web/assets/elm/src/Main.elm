module Main exposing (..)

import Array exposing (Array)
import Html
import Html.Events exposing (onClick)


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


type alias RowState =
    Array FieldState


type alias BoardState =
    Array RowState


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
    = Flip Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        whatever =
            Debug.log "incoming message" msg
    in
        case msg of
            Flip row col ->
                ( flipModel row col model, Cmd.none )


flipModel : Int -> Int -> BoardState -> BoardState
flipModel row col model =
    arrayUpdate row (flipColumn col) model


flipColumn : Int -> RowState -> RowState
flipColumn col rowState =
    arrayUpdate col flipField rowState


flipField : FieldState -> FieldState
flipField fieldState =
    case fieldState of
        Off ->
            On

        On ->
            Off


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view model =
    boardView model


fieldView : Int -> Int -> FieldState -> Html.Html Msg
fieldView row col fieldState =
    Html.td [ onClick <| Flip row col ] [ Html.text (fieldText row col fieldState) ]


rowView : Int -> RowState -> Html.Html Msg
rowView col rowState =
    Html.tr [] (Array.toList (Array.indexedMap (fieldView col) rowState))


boardView : BoardState -> Html.Html Msg
boardView boardState =
    Html.table [] (Array.toList (Array.indexedMap rowView boardState))


fieldText : a -> b -> c -> String
fieldText row col fieldState =
    (toString row) ++ " " ++ (toString col) ++ " " ++ (toString fieldState)



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
