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



-- subscriptions
-- view
