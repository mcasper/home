module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, a, div, h1, img, nav, p, text, ul)
import Html.Attributes exposing (class, href, src, style, title)



---- DATA ----


appsSeed =
    [ { name = "Budget" }
    , { name = "Score Keeper" }
    , { name = "Team Former" }
    , { name = "Movies" }
    , { name = "Recipes" }
    ]



---- MODEL ----


type alias Apps =
    List App


type alias App =
    { name : String }


type alias Model =
    { apps : Apps }


init : ( Model, Cmd Msg )
init =
    ( { apps = appsSeed }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewNav
        , h1 [ style "margin" "35px" ] [ text "Apps" ]
        , ul [] [ viewApps model.apps ]
        ]


viewNav =
    nav [ class "navbar navbar-dark bg-dark", style "height" "70px", style "color" "white" ] [ text "Home" ]


viewApps : Apps -> Html Msg
viewApps apps =
    div [ class "container", style "margin-top" "55px" ] [ div [ class "row" ] (List.map viewApp apps) ]


viewApp : App -> Html Msg
viewApp app =
    a [ style "text-decoration" "none", style "color" "black", style "display" "block", style "width" "33%", style "min-height" "300px", href "#" ]
        [ div [ style "border" "solid 1px grey", style "margin" "5px", style "height" "75%", style "border-radius" "4px", style "vertical-align" "middle", style "display" "flex" ]
            [ p [ style "margin" "auto", style "text-align" "center" ] [ text app.name ]
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
