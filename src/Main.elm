module Main exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (Html)
import AnimationFrame
import Keyboard exposing (KeyCode)
import Time exposing (Time)


---- MODEL ----


type alias Entity =
    { x : Float
    , y : Float
    , direction : Direction
    }


type Direction
    = Left
    | Right


type alias Model =
    { charactersPath : String
    , elapsedTime : Float
    , mario : Entity
    , keyPressed : String
    }


type alias Flags =
    { charactersPath : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { charactersPath = flags.charactersPath
      , elapsedTime = 0
      , mario = { x = 0, y = 0, direction = Left }
      , keyPressed = "Nothing pressed"
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = KeyDown KeyCode
    | KeyUp KeyCode
    | TimeUpdate Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeUpdate dt ->
            let
                updatedModel =
                    { model | elapsedTime = model.elapsedTime + (dt / 1000) }
            in
                ( { updatedModel | mario = moveMario dt model.keyPressed model.mario }, Cmd.none )

        KeyDown keyCode ->
            ( { model | keyPressed = toString keyCode }, Cmd.none )

        KeyUp keyCode ->
            ( { model | keyPressed = "Nothing pressed" }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        frame =
            (round model.elapsedTime) % 10
    in
        Html.div []
            [ text model.keyPressed
            , svg
                [ width "100%"
                , height "100%"
                , viewBox "0 0 640 400"
                ]
                [ drawMario model.mario model.charactersPath ]
            ]


moveMario : Time -> String -> Entity -> Entity
moveMario dt keyPressed mario =
    let
        leftArrow =
            "37"

        rightArrow =
            "39"
    in
        if keyPressed == leftArrow then
            { mario | x = mario.x - dt / 10, direction = Left }
        else if keyPressed == rightArrow then
            { mario | x = mario.x + dt / 10, direction = Right }
        else
            mario


drawMario : Entity -> String -> Svg Msg
drawMario mario spritesPath =
    let
        spriteWidth =
            16

        spriteHeight =
            16

        marioLeftSprite =
            "222 44 16 16"

        marioRightSprite =
            "276 44 16 16"

        spritePosition =
            case mario.direction of
                Left ->
                    marioLeftSprite

                Right ->
                    marioRightSprite
    in
        svg [ x (toString mario.x), y (toString mario.y), width "16px", height "16px", viewBox spritePosition, version "1.1" ]
            [ image [ x "0px", y "0px", width "513px", height "401px", xlinkHref spritesPath, imageRendering "pixelated" ] []
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs TimeUpdate
        , Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
