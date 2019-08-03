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
    [ { name = "Budget", url = "http://localhost:3000/budget", enabled = True }
    , { name = "Scoreboard", url = "http://localhost:3000/scoreboard", enabled = True }
    , { name = "Teams", url = "#", enabled = True }
    , { name = "Movies", url = "http://localhost:3000/movies", enabled = True }
    , { name = "Recipes", url = "http://localhost:3000/recipes", enabled = True }
    , { name = "Tasks", url = "http://localhost:3000/tasks", enabled = True }
    ]


productionSeed =
    [ { name = "Budget", url = "https://casper.coffee/budget", enabled = False }
    , { name = "Scoreboard", url = "https://casper.coffee/scoreboard", enabled = False }
    , { name = "Teams", url = "#", enabled = False }
    , { name = "Movies", url = "https://casper.coffee/movies", enabled = True }
    , { name = "Recipes", url = "https://casper.coffee/recipes", enabled = True }
    , { name = "Tasks", url = "https://casper.coffee/tasks", enabled = True }
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


getMe : String -> String -> Cmd Msg
getMe token webRoot =
    Http.send GotMe <|
        Http.request
            { method = "GET"
            , url = webRoot ++ "/auth/me"
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
    { name : String, url : String, enabled : Bool }


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


webRootFromConfig : Config -> String
webRootFromConfig config =
    case config.node_env of
        "development" ->
            "http://localhost:3000"

        "production" ->
            "https://casper.coffee"

        _ ->
            "http://localhost:3000"


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
        redirectToAuth config

      else
        getMe config.session (webRootFromConfig config)
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
            ( model, redirectToAuth model.config )


redirectToAuth : Config -> Cmd Msg
redirectToAuth config =
    Nav.load (webRootFromConfig config ++ "/auth/login?returnTo=" ++ webRootFromConfig config ++ "/")



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
        , a [ href "/auth/signout", style "text-decoration" "none", style "color" "white" ] [ text "Sign Out" ]
        ]


viewApps : Apps -> Html Msg
viewApps apps =
    div [ class "container", style "margin-top" "55px" ] [ div [ class "row" ] (List.map viewApp apps) ]


viewApp : App -> Html Msg
viewApp app =
    case app.enabled of
        True ->
            a [ style "text-decoration" "none", style "color" "black", style "display" "block", style "width" "33%", style "min-height" "300px", href app.url ]
                [ div [ style "border" "solid 1px grey", style "margin" "5px", style "height" "75%", style "border-radius" "4px", style "vertical-align" "middle", style "display" "flex" ]
                    [ p [ style "margin" "auto", style "text-align" "center" ] [ text app.name ]
                    ]
                ]

        False ->
            div [] []


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
