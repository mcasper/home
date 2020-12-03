module Main exposing (Model, Msg(..), init, main, update, view)

import Backend.Mutation as Mutation
import Backend.Object
import Backend.Object.Match as Match
import Backend.Object.ScoreChange as ScoreChange
import Backend.Query as Query
import Backend.Scalar exposing (Id(..))
import Browser
import Browser.Navigation as Nav
import Graphql.Http
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (Html, a, button, div, h1, img, nav, p, text, ul)
import Html.Attributes exposing (class, href, src, style, title)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import RemoteData exposing (RemoteData(..))
import Url
import Url.Parser exposing ((</>), (<?>), Parser, int, map, oneOf, s, string, top)
import Url.Parser.Query as Query


idToInt : Id -> Int
idToInt (Id id) =
    String.toInt id
        |> Maybe.withDefault 0


type alias Match =
    { id : Int
    , game : String
    , playerOne : String
    , playerTwo : String
    , scoreChanges : List ScoreChange
    }


type alias ScoreChange =
    { player : String
    , change : Int
    }


matchSelection : SelectionSet Match Backend.Object.Match
matchSelection =
    SelectionSet.succeed Match
        |> SelectionSet.with (Match.id |> SelectionSet.map idToInt)
        |> SelectionSet.with Match.game
        |> SelectionSet.with Match.playerOne
        |> SelectionSet.with Match.playerTwo
        |> SelectionSet.with (Match.scoreChanges scoreChangeSelection)


scoreChangeSelection : SelectionSet ScoreChange Backend.Object.ScoreChange
scoreChangeSelection =
    SelectionSet.succeed ScoreChange
        |> SelectionSet.with ScoreChange.player
        |> SelectionSet.with ScoreChange.change


webRootFromConfig : Config -> String
webRootFromConfig config =
    case config.node_env of
        "development" ->
            "http://localhost:3000"

        "production" ->
            "https://casper.coffee"

        _ ->
            "http://localhost:3000"


type alias Config =
    { node_env : String
    , session : String
    }


type alias Model =
    { config : Config
    , url : Url.Url
    , getMatchesResponse : RemoteData (Graphql.Http.Error (List Match)) (List Match)
    }


init : Config -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init config url key =
    ( { config = config
      , url = url
      , getMatchesResponse = NotAsked
      }
    , getMatches (webRootFromConfig config ++ "/scoreboard-backend/graphql")
    )


getMatches : String -> Cmd Msg
getMatches graphqlUrl =
    Query.matches matchSelection
        |> Graphql.Http.queryRequest graphqlUrl
        |> Graphql.Http.send (RemoteData.fromResult >> GotMatches)


createScoreChange : String -> String -> Int -> Int -> Cmd Msg
createScoreChange graphqlUrl player change matchId =
    Mutation.createScoreChange { player = player, change = change, matchId = matchId } matchSelection
        |> Graphql.Http.mutationRequest graphqlUrl
        |> Graphql.Http.send (RemoteData.fromResult >> GotMatches)



---- UPDATE ----


type Msg
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | GotMatches (RemoteData (Graphql.Http.Error (List Match)) (List Match))
    | ScoreChanged Int String Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChanged _ ->
            ( model, Cmd.none )

        LinkClicked _ ->
            ( model, Cmd.none )

        GotMatches response ->
            ( { model | getMatchesResponse = response }, Cmd.none )

        ScoreChanged matchId player change ->
            ( model, createScoreChange (webRootFromConfig model.config ++ "/scoreboard-backend/graphql") player change matchId )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "Home - Scoreboard"
    , body = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
    div [ style "height" "100%" ]
        [ viewNav
        , h1 [ style "margin" "35px" ] [ text "Scoreboard" ]
        , bodyView model.getMatchesResponse
        ]


bodyView : RemoteData (Graphql.Http.Error (List Match)) (List Match) -> Html Msg
bodyView response =
    case response of
        NotAsked ->
            text "Not Asked"

        Loading ->
            text "Loading..."

        Failure _ ->
            text "Something failed"

        Success matches ->
            div [ style "height" "100%" ] (List.map matchView matches)


matchView : Match -> Html Msg
matchView match =
    div [ class "col h-100" ]
        [ div [ class "player-one" ]
            [ div [ class "col justify-content-center align-content-center" ]
                [ p [ class "name" ] [ text match.playerOne ]
                , p [ class "score" ] [ text (String.fromInt <| scoreForPlayer match.scoreChanges match.playerOne) ]
                , div [ class "row justify-content-center" ]
                    [ button [ class "btn", onClick (ScoreChanged match.id match.playerOne -1) ] [ text "-" ]
                    , button [ class "btn ml-4", onClick (ScoreChanged match.id match.playerOne 1) ] [ text "+" ]
                    ]
                ]
            ]
        , div [ class "player-two" ]
            [ div [ class "col" ]
                [ p [ class "name" ] [ text match.playerTwo ]
                , p [ class "score" ] [ text (String.fromInt <| scoreForPlayer match.scoreChanges match.playerTwo) ]
                , div [ class "row justify-content-center" ]
                    [ button [ class "btn", onClick (ScoreChanged match.id match.playerTwo -1) ] [ text "-" ]
                    , button [ class "btn ml-4", onClick (ScoreChanged match.id match.playerTwo 1) ] [ text "+" ]
                    ]
                ]
            ]
        ]


scoreForPlayer : List ScoreChange -> String -> Int
scoreForPlayer scoreChanges player =
    List.foldl
        (\scoreChange acc ->
            if scoreChange.player == player then
                acc + scoreChange.change

            else
                acc
        )
        0
        scoreChanges


viewNav =
    nav [ class "navbar navbar-dark bg-dark", style "height" "70px", style "color" "white" ]
        [ div []
            [ a [ href "/scoreboard", style "text-decoration" "none", style "color" "white" ] [ text "Scoreboard" ]
            , text "\n|\n"
            , a [ href "/", style "text-decoration" "none", style "color" "white" ] [ text "Back to Home" ]
            ]
        , div []
            [ a [ href "/scoreboard/matches/new", style "text-decoration" "none", style "color" "white" ]
                [ text "New"
                ]
            , text "\n|\n"
            , a [ href "/auth/signout", style "text-decoration" "none", style "color" "white" ] [ text "Sign Out" ]
            ]
        ]


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
