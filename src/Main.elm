module Main exposing (..)

import Animation
import Animation.Messenger
import Html exposing (Html, a, button, code, div, footer, h2, h3, li, p, span, text, ul)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import List.Extra as ListX
import Tuple


---- MODEL ----


type alias Model =
    { fruits : List Fruit }


type alias Fruit =
    { name : String
    , emoji : String
    , style : Animation.Messenger.State Msg
    }


init : ( Model, Cmd Msg )
init =
    let
        initStyle =
            Animation.style
                [ Animation.opacity 1.0
                , Animation.translate3d (Animation.px 0) (Animation.px 0) (Animation.px 0)
                ]
    in
    ( { fruits =
            [ { name = "pineapple"
              , emoji = "🍍"
              , style = initStyle
              }
            , { name = "watermelon"
              , emoji = "🍉"
              , style = initStyle
              }
            , { name = "apple"
              , emoji = "🍏"
              , style = initStyle
              }
            , { name = "cherries"
              , emoji = "🍒"
              , style = initStyle
              }
            , { name = "pear"
              , emoji = "🍐"
              , style = initStyle
              }
            ]
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Animate Animation.Msg
    | FadeOutUp String Msg
    | RemoveItem String
    | Reset
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Animate animMsg ->
            let
                updateFruit : Fruit -> ( Fruit, Cmd Msg )
                updateFruit fruit =
                    let
                        ( newStyle, cmd ) =
                            Animation.Messenger.update animMsg fruit.style

                        newFruit =
                            { fruit | style = newStyle }
                    in
                    ( newFruit, cmd )

                newFruits : List Fruit
                newFruits =
                    List.map Tuple.first <| List.map updateFruit model.fruits

                commands : List (Cmd Msg)
                commands =
                    List.map Tuple.second <| List.map updateFruit model.fruits
            in
            ( { model | fruits = newFruits }, Cmd.batch commands )

        FadeOutUp name msg ->
            case fruitFromName name model.fruits of
                Just fruit ->
                    let
                        newStyle : Fruit -> Animation.Messenger.State Msg
                        newStyle f =
                            Animation.interrupt
                                [ Animation.to
                                    [ Animation.opacity 0
                                    , Animation.translate3d (Animation.px 0) (Animation.percent -100) (Animation.px 0)
                                    ]
                                , Animation.Messenger.send msg
                                ]
                                f.style

                        updatedFruit =
                            { fruit | style = newStyle fruit }

                        newFruits =
                            ListX.replaceIf (\f -> f == fruit) updatedFruit model.fruits
                    in
                    ( { model | fruits = newFruits }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        RemoveItem name ->
            case fruitFromName name model.fruits of
                Just f ->
                    ( { model | fruits = removeFruit f model.fruits }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        Reset ->
            init

        NoOp ->
            ( model, Cmd.none )


fruitFromName : String -> List Fruit -> Maybe Fruit
fruitFromName name allFruits =
    ListX.find (\f -> f.name == name) allFruits


updateStyle : (Animation.Messenger.State Msg -> Animation.Messenger.State Msg) -> Fruit -> Fruit
updateStyle styleFN fruit =
    { fruit | style = styleFN fruit.style }


removeFruit : Fruit -> List Fruit -> List Fruit
removeFruit fruit allFruits =
    List.filter (\f -> f /= fruit) allFruits



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        instruction =
            if List.isEmpty model.fruits then
                div [ class "reset" ]
                    [ text "All gone!"
                    , button [ class "button", onClick Reset ] [ text "Reset" ]
                    ]
            else
                div [] [ text "Here is a list of fruits:" ]
    in
    div [ class "container" ]
        [ h2 [ class "is-size-1 has-text-link demo cursive" ] [ text "Elm Demo" ]
        , p [ class "is-size-4 has-background-light line" ]
            [ code [] [ text "elm-style-animation" ], text " with secondary effects" ]
        , p [ class "is-size-6 has-background-light line" ]
            [ text "Animation ("
            , code [] [ text "FadeOut" ]
            , text ") then action ("
            , code [] [ text "RemoveItem" ]
            , text ")"
            ]
        , div [ class "is-size-5 line instruction" ] [ instruction ]
        , ul [ class "line" ] (List.map listItem model.fruits)
        , footer [ class "has-background-light source-code" ]
            [ a [ href "https://github.com/kfrn/elm-animate-list-items.git", class "is-size-4 cursive" ] [ text "source code!" ] ]
        ]


listItem : Fruit -> Html Msg
listItem fruit =
    li (Animation.render fruit.style ++ [ class "is-size-6 fruit" ])
        [ span [ class "has-background-link has-text-white is-size-4 emoji" ] [ text fruit.emoji ]
        , span [ class "fruit-name" ] [ text fruit.name ]
        , span []
            [ button
                [ class "button is-narrow"
                , onClick <| FadeOutUp fruit.name (RemoveItem fruit.name)
                ]
                [ text "❌" ]
            ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate (List.map .style model.fruits)
