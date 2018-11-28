module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, div, h1, img, nav, p, text, ul)
import Html.Attributes exposing (class, href, src, style, title)
import Url



---- DATA ----
---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Home"
    , body = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
    div []
        [ viewNav
        , h1 [ style "margin" "35px" ] [ text "Scoreboard" ]
        ]


viewNav =
    nav [ class "navbar navbar-dark bg-dark", style "height" "70px", style "color" "white" ]
        [ div []
            [ a [ href "#", style "text-decoration" "none", style "color" "white" ] [ text "Scoreboard" ]
            , text "\n|\n"
            , a [ href "http://localhost:3000/", style "text-decoration" "none", style "color" "white" ] [ text "Back to Home" ]
            ]
        , div []
            [ a [ href "#", style "text-decoration" "none", style "color" "white" ]
                [ text "Edit"
                ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
