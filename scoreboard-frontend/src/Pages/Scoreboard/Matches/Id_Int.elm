module Pages.Scoreboard.Matches.Id_Int exposing (Model, Msg, Params, page)

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
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = save
        , load = load
        }


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



-- INIT


type alias Params =
    { id : Int }


type alias Model =
    { config : Shared.Config
    , url : Url Params
    , getMatchResponse : RemoteData (Graphql.Http.Error Match) Match
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared url =
    ( { config = shared.config
      , url = url
      , getMatchResponse = NotAsked
      }
    , getMatch url.params.id "/scoreboard-backend/graphql"
    )


getMatch : Int -> String -> Cmd Msg
getMatch id graphqlUrl =
    Query.match { id = Id (String.fromInt id) } matchSelection
        |> Graphql.Http.queryRequest graphqlUrl
        |> Graphql.Http.send (RemoteData.fromResult >> GotMatch)


createScoreChange : String -> String -> Int -> Int -> Cmd Msg
createScoreChange graphqlUrl player change matchId =
    Mutation.createScoreChange { player = player, change = change, matchId = matchId } matchSelection
        |> Graphql.Http.mutationRequest graphqlUrl
        |> Graphql.Http.send (RemoteData.fromResult >> GotMatch)



-- UPDATE


type Msg
    = GotMatch (RemoteData (Graphql.Http.Error Match) Match)
    | ScoreChanged Int String Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMatch response ->
            ( { model | getMatchResponse = response }, Cmd.none )

        ScoreChanged matchId player change ->
            ( model, createScoreChange "/scoreboard-backend/graphql" player change matchId )


save : Model -> Shared.Model -> Shared.Model
save model shared =
    shared


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Home - Scoreboard"
    , body = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
    div [ style "height" "100%" ]
        [ viewNav
        , h1 [ style "margin" "35px" ] [ text "Scoreboard" ]
        , bodyView model.getMatchResponse
        ]


bodyView : RemoteData (Graphql.Http.Error Match) Match -> Html Msg
bodyView response =
    case response of
        NotAsked ->
            text "Not Asked"

        Loading ->
            text "Loading..."

        Failure _ ->
            text "Something failed"

        Success match ->
            div [ style "height" "100%" ] [ matchView match ]


matchView : Match -> Html Msg
matchView match =
    div [ class "col h-100" ]
        [ div [ class "player-one" ]
            [ div [ class "col justify-content-center align-content-center" ]
                [ p [ class "name" ] [ text match.playerOne ]
                , p [ class "score" ] [ text (String.fromInt <| scoreForPlayer match.scoreChanges match.playerOne) ]
                , div [ class "row h-100 justify-content-center" ]
                    [ button [ class "btn btn-light w-25 h-25", onClick (ScoreChanged match.id match.playerOne -1) ] [ text "-" ]
                    , button [ class "btn btn-light w-25 h-25 ml-4", onClick (ScoreChanged match.id match.playerOne 1) ] [ text "+" ]
                    ]
                ]
            ]
        , div [ class "player-two" ]
            [ div [ class "col" ]
                [ p [ class "name" ] [ text match.playerTwo ]
                , p [ class "score" ] [ text (String.fromInt <| scoreForPlayer match.scoreChanges match.playerTwo) ]
                , div [ class "row h-100 justify-content-center" ]
                    [ button [ class "btn btn-light w-25 h-25", onClick (ScoreChanged match.id match.playerTwo -1) ] [ text "-" ]
                    , button [ class "btn btn-light w-25 h-25 ml-4", onClick (ScoreChanged match.id match.playerTwo 1) ] [ text "+" ]
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
            , a [ href "/scoreboard", style "text-decoration" "none", style "color" "white" ] [ text "Back to Matches" ]
            ]
        , div []
            [ a [ href "/scoreboard/matches/new", style "text-decoration" "none", style "color" "white" ]
                [ text "New"
                ]
            , text "\n|\n"
            , a [ href "/auth/signout", style "text-decoration" "none", style "color" "white" ] [ text "Sign Out" ]
            ]
        ]
