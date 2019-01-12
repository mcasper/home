module Main exposing (Model, Msg(..), Route(..), init, main, parseRoute, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, div, h1, img, nav, p, text, ul)
import Html.Attributes exposing (class, href, src, style, title)
import Url
import Url.Parser exposing ((</>), (<?>), Parser, int, map, oneOf, s, string, top)
import Url.Parser.Query as Query



---- ROUTES ----


type Route
    = MatchesIndex (Maybe String)
    | MatchesNew


parseRoute : Url.Url -> Maybe Route
parseRoute url =
    Url.Parser.parse routeParser url


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map MatchesIndex (s "scoreboard" <?> Query.string "q")
        , map MatchesIndex (s "scoreboard" </> s "matches" <?> Query.string "q")
        , map MatchesNew (s "scoreboard" </> s "matches" </> s "new")
        ]



---- DATA TYPES ----


type alias Player =
    { name : String }


type alias Score =
    { value : Int }


type alias Team =
    { players : List Player
    , scores : List Score
    , name : Maybe String
    }


type alias Match =
    { game : String
    , teams : List Team
    }



---- DATA ----


matchesSeed =
    [ { game = "Sequence"
      , teams =
            [ { players =
                    [ { name = "Matt"
                      }
                    ]
              , scores =
                    [ { value = 1 }
                    , { value = 1 }
                    , { value = 3 }
                    ]
              , name = Nothing
              }
            , { players =
                    [ { name = "Ashlyn"
                      }
                    ]
              , scores =
                    [ { value = 1 }
                    , { value = 1 }
                    , { value = 2 }
                    ]
              , name = Nothing
              }
            ]
      }
    , { game = "Sequence"
      , teams =
            [ { players =
                    [ { name = "Kim"
                      }
                    ]
              , scores =
                    [ { value = 1 }
                    , { value = 1 }
                    , { value = 3 }
                    ]
              , name = Nothing
              }
            , { players =
                    [ { name = "Neal"
                      }
                    ]
              , scores =
                    [ { value = 1 }
                    , { value = 1 }
                    , { value = 2 }
                    ]
              , name = Nothing
              }
            ]
      }
    , { game = "Sequence"
      , teams =
            [ { players =
                    [ { name = "Kim"
                      }
                    , { name = "Neal"
                      }
                    ]
              , scores =
                    [ { value = 1 }
                    , { value = 1 }
                    , { value = 3 }
                    ]
              , name = Just "The Parents"
              }
            , { players =
                    [ { name = "Matthew"
                      }
                    , { name = "Ashley"
                      }
                    ]
              , scores =
                    [ { value = 1 }
                    , { value = 1 }
                    , { value = 2 }
                    ]
              , name = Just "The Awesomes"
              }
            , { players =
                    [ { name = "Audrey"
                      }
                    , { name = "Ashlyn"
                      }
                    ]
              , scores =
                    [ { value = 1 }
                    , { value = 1 }
                    , { value = 2 }
                    ]
              , name = Just "The Girls"
              }
            ]
      }
    ]



---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , route : Maybe Route
    , matches : List Match
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url (parseRoute url) matchesSeed, Cmd.none )



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
                    case parseRoute url of
                        Nothing ->
                            ( model, Nav.load (Url.toString url) )

                        Just _ ->
                            ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = parseRoute url }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = titleForRoute model.route
    , body = [ viewBody model ]
    }


titleForRoute : Maybe Route -> String
titleForRoute route =
    case route of
        Just (MatchesIndex query) ->
            "Scoreboard - Matches"

        Just MatchesNew ->
            "Scoreboard - New Match"

        Nothing ->
            "Scoreboard"


viewBody : Model -> Html Msg
viewBody model =
    case model.route of
        Just (MatchesIndex query) ->
            div []
                [ viewNav
                , h1 [ style "margin" "35px" ] [ text "Scoreboard" ]
                , viewMatches model
                ]

        Just MatchesNew ->
            div []
                [ viewNav
                , h1 [ style "margin" "35px" ] [ text "New Scoreboard" ]
                ]

        Nothing ->
            div [] [ text "Uh oh, 404!" ]


viewNav =
    nav [ class "navbar navbar-dark bg-dark", style "height" "70px", style "color" "white" ]
        [ div []
            [ a [ href "/scoreboard", style "text-decoration" "none", style "color" "white" ] [ text "Scoreboard" ]
            , text "\n|\n"
            , a [ href "/", style "text-decoration" "none", style "color" "white" ] [ text "Back to Home" ]
            ]
        , div []
            [ a [ href "/matches/new", style "text-decoration" "none", style "color" "white" ]
                [ text "New"
                ]
            ]
        ]


viewMatches : Model -> Html Msg
viewMatches model =
    ul []
        [ div [ class "container" ] (List.map viewMatch model.matches)
        ]


viewMatch : Match -> Html Msg
viewMatch match =
    div [ class "container row border-bottom", style "min-height" "75px", style "margin-top" "10px" ]
        [ p [ class "col text-left" ] [ text match.game ]
        , viewTeams match.teams
        , p [ class "col text-right" ] [ text ">" ]
        ]


viewTeams : List Team -> Html Msg
viewTeams teams =
    div [ class "col-6 container row justify-content-center" ] (List.map viewTeam teams)


viewTeam : Team -> Html Msg
viewTeam team =
    let
        playerNames =
            List.map .name team.players
                |> String.join ", "

        teamName =
            Maybe.withDefault playerNames team.name
    in
    div [ class "col" ]
        [ div [ class "col" ] [ text teamName ]
        , div [ class "col" ] [ text "1" ]
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
