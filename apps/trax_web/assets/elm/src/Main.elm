module Main exposing (..)

import Html


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    Int


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


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
    Html.text "hello from normal program"
