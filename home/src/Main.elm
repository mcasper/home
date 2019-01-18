module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, div, h1, img, nav, p, text, ul)
import Html.Attributes exposing (class, href, src, style, title)
import Http
import Json.Decode as Json
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



---- JWT ----


getMe : String -> Cmd Msg
getMe token =
    Http.send GotMe <|
        Http.request
            { method = "GET"
            , url = "http://localhost:3000/auth/me"
            , expect = Http.expectJson userDecoder
            , headers = [ Http.header "Authorization" ("Bearer " ++ token) ]
            , body = Http.emptyBody
            , timeout = Nothing
            , withCredentials = False
            }


userDecoder : Json.Decoder User
userDecoder =
    Json.map User
        (Json.field "name" Json.string)



---- MODEL ----


type alias User =
    { name : String }


type alias Apps =
    List App


type alias App =
    { name : String, url : String }


type alias Config =
    { node_env : String
    , session : String
    }


type alias Model =
    { config : Config
    , apps : Apps
    , key : Nav.Key
    , url : Url.Url
    , route : Maybe Route
    , isAuthed : Bool
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
    ( { config = config
      , apps = seedFromConfig config
      , key = key
      , url = url
      , route = parseRoute url
      , isAuthed = False
      }
    , if config.session == "" then
        redirectToAuth

      else
        getMe config.session
    )



---- UPDATE ----


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotMe (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    case parseRoute url of
                        Nothing ->
                            ( model, Nav.load (Url.toString url) )

                        Just _ ->
                            ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged _ ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        GotMe (Ok user) ->
            ( { model | isAuthed = True }, Cmd.none )

        GotMe (Err error) ->
            ( model, redirectToAuth )


redirectToAuth : Cmd Msg
redirectToAuth =
    Nav.load "http://localhost:3000/auth/login?returnTo=http://localhost:3000/"



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    case model.isAuthed of
        True ->
            { title = "Home"
            , body = [ viewBody model ]
            }

        False ->
            { title = "Home"
            , body = [ unauthenticatedView ]
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


unauthenticatedView : Html Msg
unauthenticatedView =
    div [] [ text "Please authenticate" ]



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
