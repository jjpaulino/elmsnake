import Html.App as App
import Window
import Time exposing (Time)
import Random
import Keyboard
import Task
import Htmlimport Html.Attributes exposing (style)
import Svg exposing (..)
import Svg.Attributes exposing (..)

main =
  App.program {init = ( init, initCmds ), update = update, view = view, subscriptions = subscriptions }

-- model

type alias Game =
    { direction : Direction
    , dimensions : Widow.size
    , snake : Snake
    , isDead : Bool
    , apple : Maybe Block
    , ateApple : Bool
    }

type alias Block =
    { x : Int
    , y : Int
    }

type alias Snake =
    List Block

type Directionn
    = Up
    | Down
    | Left
    | Right

type Keys
    = NoKey
  | LeftKey
  |RightKey
  |UpKey
  |DownKey

  type alias AppleSpawn =
      { position : ( Int, Int )
      , chance : Int
      }

initSnake : Snake
initSnake =
    [ Block 25 25
    , Block 24 25
    , Block 23 25
    ]


init : Game
init =
    { direction = Right
    , dimensions = Window.Size 0 0
    , snake = initSnake
    , isDead = False
    , apple = Nothing
    , ateApple = False
    }



-- update

type Msg
    = ArrowPressed Keys
    | SizeUpdated Window.Size
    | Tick Time
    | MaybeSpawnApple AppleSpawn

update : Msg -> Game -> ( Game, Cmd Msg )
update msg game =
    case msg of
        ArrowPressed arrow ->
            ( updateDirection arrow game, Cmd.none )

        SizeUpdated dimensions ->
            ( { game | dimensions = dimensions }, Cmd.none )

        Tick time ->
            updateGame game

        MaybeSpawnApple spawn ->
            if spawn.chance == 0 then
                ( spanwApple game spawn, Cmd.none )
            else
                ( game, Cmd.none )
                    |> checkIfOutOfBounds
                    |> checkIfEatenSelf
                    |> checkIfAteApple
                    |> updateSnake
                    |> updateApple

 checkIfEatenSelf : ( Game, Cmd Msg ) -> ( Game, Cmd Msg)
 checkIfEatenSelf ( game, cmd) =
   let
          head =
              snakeHead game.snake

          tail =
              List.drop 1 game.snake

          isDead =
              game.isDead || List.any ( samePosition head ) tail

    in
      ( { game | isDead = isDead }, cmd )

checkifAteApple : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
checkIfAteApple ( game, cmd ) =
    let
        head =
            snakeHead game.snake

    in
        case game.apple of
            Nothing ->
                ( { game | ateApple = False }, cmd )
            Just apple ->
                ( { game | ateApple = samePosition head apple }, cmd )

samePosition : Block -> Block -> Bool
samePosition a b =
    a.x == b.x && a.y == b.y


checkIfOutOfBounds : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
checkIfOutOfBounds =
  let
      head =
            snakehead game.snake
      isDead =
            ( head.x == 0 && game.direction === Left )
            || ( head.y == 0 && game.direction == Up )
            || ( head.x == 49 && game.direction == Right )
            || ( head.y == 49 && game.direction == Down )

snakeHead : Snake -> Block
snakeHead snake =
    List.head snake
        |> Maybe.withDefault { x = 0, y = 0 }

-- subscriptions
-- view
