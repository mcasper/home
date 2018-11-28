module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, div, h1, img, nav, p, text, ul)
import Html.Attributes exposing (class, href, src, style, title)
import Url



---- DATA ----


appsSeed =
    [ { name = "Budget", url = "http://localhost:3001" }
    , { name = "Score Keeper", url = "#" }
    , { name = "Team Former", url = "#" }
    , { name = "Movies", url = "http://localhost:3002" }
    , { name = "Recipes", url = "#" }
    ]



---- MODEL ----


type alias Apps =
    List App


type alias App =
    { name : String, url : String }


type alias Model =
    { apps : Apps
    , key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model appsSeed key url, Cmd.none )



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
        , h1 [ style "margin" "35px" ] [ text "Apps" ]
        , ul [] [ viewApps model.apps ]
        ]


viewNav =
    nav [ class "navbar navbar-dark bg-dark", style "height" "70px", style "color" "white" ]
        [ text "Home"
        , a [ href "#", style "text-decoration" "none", style "color" "white" ] [ text "Edit" ]
        ]


viewApps : Apps -> Html Msg
viewApps apps =
    div [ class "container", style "margin-top" "55px" ] [ div [ class "row" ] (List.map viewApp apps) ]


viewApp : App -> Html Msg
viewApp app =
    a [ style "text-decoration" "none", style "color" "black", style "display" "block", style "width" "33%", style "min-height" "300px", href app.url ]
        [ div [ style "border" "solid 1px grey", style "margin" "5px", style "height" "75%", style "border-radius" "4px", style "vertical-align" "middle", style "display" "flex" ]
            [ p [ style "margin" "auto", style "text-align" "center" ] [ text app.name ]
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
