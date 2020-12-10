module Spa.Generated.Pages exposing
    ( Model
    , Msg
    , init
    , load
    , save
    , subscriptions
    , update
    , view
    )

import Pages.NotFound
import Pages.Scoreboard
import Pages.Scoreboard.Matches.Id_Int
import Shared
import Spa.Document as Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page exposing (Page)
import Spa.Url as Url


-- TYPES


type Model
    = NotFound__Model Pages.NotFound.Model
    | Scoreboard__Model Pages.Scoreboard.Model
    | Scoreboard__Matches__Id_Int__Model Pages.Scoreboard.Matches.Id_Int.Model


type Msg
    = NotFound__Msg Pages.NotFound.Msg
    | Scoreboard__Msg Pages.Scoreboard.Msg
    | Scoreboard__Matches__Id_Int__Msg Pages.Scoreboard.Matches.Id_Int.Msg



-- INIT


init : Route -> Shared.Model -> ( Model, Cmd Msg )
init route =
    case route of
        Route.NotFound ->
            pages.notFound.init ()
        
        Route.Scoreboard ->
            pages.scoreboard.init ()
        
        Route.Scoreboard__Matches__Id_Int params ->
            pages.scoreboard__matches__id_int.init params



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update bigMsg bigModel =
    case ( bigMsg, bigModel ) of
        ( NotFound__Msg msg, NotFound__Model model ) ->
            pages.notFound.update msg model
        
        ( Scoreboard__Msg msg, Scoreboard__Model model ) ->
            pages.scoreboard.update msg model
        
        ( Scoreboard__Matches__Id_Int__Msg msg, Scoreboard__Matches__Id_Int__Model model ) ->
            pages.scoreboard__matches__id_int.update msg model
        
        _ ->
            ( bigModel, Cmd.none )



-- BUNDLE - (view + subscriptions)


bundle : Model -> Bundle
bundle bigModel =
    case bigModel of
        NotFound__Model model ->
            pages.notFound.bundle model
        
        Scoreboard__Model model ->
            pages.scoreboard.bundle model
        
        Scoreboard__Matches__Id_Int__Model model ->
            pages.scoreboard__matches__id_int.bundle model


view : Model -> Document Msg
view model =
    (bundle model).view ()


subscriptions : Model -> Sub Msg
subscriptions model =
    (bundle model).subscriptions ()


save : Model -> Shared.Model -> Shared.Model
save model =
    (bundle model).save ()


load : Model -> Shared.Model -> ( Model, Cmd Msg )
load model =
    (bundle model).load ()



-- UPGRADING PAGES


type alias Upgraded params model msg =
    { init : params -> Shared.Model -> ( Model, Cmd Msg )
    , update : msg -> model -> ( Model, Cmd Msg )
    , bundle : model -> Bundle
    }


type alias Bundle =
    { view : () -> Document Msg
    , subscriptions : () -> Sub Msg
    , save : () -> Shared.Model -> Shared.Model
    , load : () -> Shared.Model -> ( Model, Cmd Msg )
    }


upgrade : (model -> Model) -> (msg -> Msg) -> Page params model msg -> Upgraded params model msg
upgrade toModel toMsg page =
    let
        init_ params shared =
            page.init shared (Url.create params shared.key shared.url) |> Tuple.mapBoth toModel (Cmd.map toMsg)

        update_ msg model =
            page.update msg model |> Tuple.mapBoth toModel (Cmd.map toMsg)

        bundle_ model =
            { view = \_ -> page.view model |> Document.map toMsg
            , subscriptions = \_ -> page.subscriptions model |> Sub.map toMsg
            , save = \_ -> page.save model
            , load = \_ -> load_ model
            }

        load_ model shared =
            page.load shared model |> Tuple.mapBoth toModel (Cmd.map toMsg)
    in
    { init = init_
    , update = update_
    , bundle = bundle_
    }


pages :
    { notFound : Upgraded Pages.NotFound.Params Pages.NotFound.Model Pages.NotFound.Msg
    , scoreboard : Upgraded Pages.Scoreboard.Params Pages.Scoreboard.Model Pages.Scoreboard.Msg
    , scoreboard__matches__id_int : Upgraded Pages.Scoreboard.Matches.Id_Int.Params Pages.Scoreboard.Matches.Id_Int.Model Pages.Scoreboard.Matches.Id_Int.Msg
    }
pages =
    { notFound = Pages.NotFound.page |> upgrade NotFound__Model NotFound__Msg
    , scoreboard = Pages.Scoreboard.page |> upgrade Scoreboard__Model Scoreboard__Msg
    , scoreboard__matches__id_int = Pages.Scoreboard.Matches.Id_Int.page |> upgrade Scoreboard__Matches__Id_Int__Model Scoreboard__Matches__Id_Int__Msg
    }