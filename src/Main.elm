module Main exposing (..)

import Animation
import Animation.Messenger
import Html exposing (Html, button, div, h2, h3, img, li, p, span, text, ul)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)


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
    ( { fruits =
            [ { name = "banana"
              , emoji = "🍌"
              , style =
                    Animation.style
                        [ Animation.opacity 1.0
                        ]
              }
            , { name = "apple"
              , emoji = "🍏"
              , style =
                    Animation.style
                        [ Animation.opacity 1.0
                        ]
              }
            , { name = "pear"
              , emoji = "🍐"
              , style =
                    Animation.style
                        [ Animation.opacity 1.0
                        ]
              }
            ]
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Animate Animation.Msg
    | RemoveItem Fruit
    | Reset
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Animate animMsg ->
            let
                newModel =
                    { model
                        | fruits =
                            List.map
                                (updateStyle <| Animation.update animMsg)
                                model.fruits
                    }
            in
            ( newModel, Cmd.none )

        RemoveItem fruit ->
            let
                otherFruits =
                    removeFruit fruit model.fruits
            in
            ( { model | fruits = otherFruits }, Cmd.none )

        Reset ->
            init

        NoOp ->
            ( model, Cmd.none )


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
                div []
                    [ text "All gone!"
                    , button [ class "button", onClick Reset ] [ text "Reset" ]
                    ]
            else
                div [] [ text "Here is a list of fruits:" ]
    in
    div []
        [ h2 [] [ text "Demo" ]
        , p [] [ text "elm-style-animation with secondary effects" ]
        , h3 [] [ instruction ]
        , ul [] (List.map listItem model.fruits)
        ]


listItem : Fruit -> Html Msg
listItem fruit =
    li (Animation.render fruit.style)
        [ span [ class "emoji" ] [ text fruit.emoji ]
        , text fruit.name
        , button [ class "button", onClick <| RemoveItem fruit ] [ text "❌" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate (List.map .style model.fruits)
