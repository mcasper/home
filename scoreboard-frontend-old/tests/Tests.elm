module Tests exposing (all)

import Expect
import Main
import Test exposing (..)
import Url



-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


type alias RouteTestInput =
    { url : String
    , expected : Maybe Main.Route
    }


matchesIndexRouteTestInputs =
    [ { url = "http://localhost:3000", expected = Just (Main.MatchesIndex Nothing) }
    , { url = "http://localhost:3000?q=mine", expected = Just (Main.MatchesIndex (Just "mine")) }
    , { url = "http://localhost:3000/", expected = Just (Main.MatchesIndex Nothing) }
    , { url = "http://localhost:3000/?q=all", expected = Just (Main.MatchesIndex (Just "all")) }
    , { url = "http://localhost:3000/matches", expected = Just (Main.MatchesIndex Nothing) }
    , { url = "http://localhost:3000/matches?q=all", expected = Just (Main.MatchesIndex (Just "all")) }
    , { url = "http://localhost:3000/matches/?q=all", expected = Just (Main.MatchesIndex (Just "all")) }
    ]


matchesNewRouteTestInputs =
    [ { url = "http://localhost:3000/matches/new", expected = Just Main.MatchesNew }
    , { url = "http://localhost:3000/matches/new/", expected = Just Main.MatchesNew }
    , { url = "http://localhost:3000/matches/new?q=all", expected = Just Main.MatchesNew }
    , { url = "http://localhost:3000/matches/new/?q=all", expected = Just Main.MatchesNew }
    ]


generateRouteTest : Int -> RouteTestInput -> Test
generateRouteTest index input =
    case Url.fromString input.url of
        Just url ->
            test (String.fromInt index ++ ". " ++ Url.toString url ++ " routes to appropriate thing") <|
                \_ ->
                    Expect.equal input.expected (Main.parseRoute url)

        Nothing ->
            test "Failed test generation" <|
                \_ ->
                    Expect.fail "Failure!"


all : Test
all =
    describe "Routing Test Suite"
        [ describe "Matches Index Routing"
            (List.indexedMap generateRouteTest matchesIndexRouteTestInputs)
        , describe "Matches New Routing"
            (List.indexedMap generateRouteTest matchesNewRouteTestInputs)
        ]
