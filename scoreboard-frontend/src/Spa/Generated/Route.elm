module Spa.Generated.Route exposing
    ( Route(..)
    , fromUrl
    , toString
    )

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = NotFound
    | Scoreboard
    | Scoreboard__Matches__Id_Int { id : Int }


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse routes


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map NotFound (Parser.s "not-found")
        , Parser.map Scoreboard (Parser.s "scoreboard")
        , (Parser.s "scoreboard" </> Parser.s "matches" </> Parser.int)
          |> Parser.map (\id -> { id = id })
          |> Parser.map Scoreboard__Matches__Id_Int
        ]


toString : Route -> String
toString route =
    let
        segments : List String
        segments =
            case route of
                NotFound ->
                    [ "not-found" ]
                
                Scoreboard ->
                    [ "scoreboard" ]
                
                Scoreboard__Matches__Id_Int { id } ->
                    [ "scoreboard", "matches", String.fromInt id ]
    in
    segments
        |> String.join "/"
        |> String.append "/"