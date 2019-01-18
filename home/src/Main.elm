module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, div, h1, img, nav, p, text, ul)
import Html.Attributes exposing (class, href, src, style, title)
import Url
import Url.Parser exposing ((</>), (<?>), Parser, int, map, oneOf, s, string, top)
import Url.Parser.Query as Query



---- DATA ----


developmentSeed =
    [ { name = "Budget", url = "http://localhost:3000/budget" }
    , { name = "Scoreboard", url = "http://localhost:3000/scoreboard" }
    , { name = "Teams", url = "#" }
    , { name = "Movies", url = "http://localhost:3000/movies" }
    , { name = "Recipes", url = "http://localhost:3000/recipes" }
    ]

productionSeed =
    [ { name = "Budget", url = "https://casper.coffee/budget" }
    , { name = "Scoreboard", url = "https://casper.coffee/scoreboard" }
    , { name = "Teams", url = "#" }
    , { name = "Movies", url = "https://casper.coffee/movies" }
    , { name = "Recipes", url = "https://casper.coffee/recipes" }
    ]


---- ROUTES ----

type Route
    = Apps


parseRoute : Url.Url -> Maybe Route
parseRoute url =
    Url.Parser.parse routeParser url


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Apps top
        ]



---- MODEL ----


type alias Apps =
    List App


type alias App =
    { name : String, url : String }


type alias Config =
    { node_env : String
    , session : String }


type alias Model =
    { config : Config
    , apps : Apps
    , key : Nav.Key
    , url : Url.Url
    , route : Maybe Route
    }


seedFromConfig : Config -> Apps
seedFromConfig config =
  case config.node_env of
    "development" ->
      developmentSeed

    "production" ->
      productionSeed

    _ ->
      developmentSeed


init : Config -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init config url key =
    ( Model config (seedFromConfig config) key url (parseRoute url), Cmd.none )



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
                  case (parseRoute url) of
                    Nothing ->
                      ( model, Nav.load (Url.toString url) )
                    Just _ ->
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


main : Program Config Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
