module Pages.Scoreboard exposing (Model, Msg, Params, page)

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
    ()


type alias Model =
    { config : Shared.Config
    , url : Url Params
    , getMatchesResponse : RemoteData (Graphql.Http.Error (List Match)) (List Match)
    }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared url =
    ( { config = shared.config
      , url = url
      , getMatchesResponse = NotAsked
      }
    , getMatches "/scoreboard-backend/graphql"
    )


getMatches : String -> Cmd Msg
getMatches graphqlUrl =
    Query.matches matchSelection
        |> Graphql.Http.queryRequest graphqlUrl
        |> Graphql.Http.send (RemoteData.fromResult >> GotMatches)



-- UPDATE


type Msg
    = GotMatches (RemoteData (Graphql.Http.Error (List Match)) (List Match))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotMatches response ->
            ( { model | getMatchesResponse = response }, Cmd.none )


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
    div [ class "h-100" ]
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
    div [ class "container" ]
        [ a [ href ("/scoreboard/matches/" ++ String.fromInt match.id) ] [ text (match.game ++ " - " ++ match.playerOne ++ " vs " ++ match.playerTwo) ]
        ]


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
