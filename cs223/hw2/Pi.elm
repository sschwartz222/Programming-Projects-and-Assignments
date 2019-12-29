module Pi exposing (..)

-- Add/modify imports if you'd like. ---------------------------------

import Browser
import Html exposing (Html)
import Html.Events
import Random exposing (Generator)
import Time exposing (..)
import Debug
import Svg exposing (..)
import Svg.Attributes exposing (..)
----------------------------------------------------------------------

main : Program Flags Model Msg
main = 
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Point = { x:Float, y:Float }

type alias Model =
  { hits : List Point
  , misses : List Point
  , hitCount : Int
  , missCount : Int
  }

type Msg = Tick | RandomPoint Point

type alias Flags = ()

init : Flags -> (Model, Cmd Msg)
init () =
  (initModel, Cmd.none)

initModel : Model
initModel =
  {hits = []
  ,misses = []
  ,hitCount = 0
  ,missCount = 0
  }

maketick : Posix -> Msg
maketick p =
  Tick

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1 maketick

pointGenerator : Generator Point
pointGenerator =
  Random.map2 Point (Random.float 0 500) (Random.float 0 500)

distance : Point -> Bool
distance p =
    if (sqrt (((p.x - 250) ^ 2) + ((p.y - 250) ^ 2))) <= 250 then True else False

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick -> (model, Random.generate RandomPoint pointGenerator)
    RandomPoint pt -> 
      if (distance pt) == True 
        then 
          ({model | hits = pt :: model.hits, hitCount = model.hitCount + 1}, Cmd.none) 
        else 
          ({model | misses = pt :: model.misses, missCount = model.missCount + 1}, Cmd.none)

pointtocircle : Point -> Svg msg
pointtocircle pt =
  if distance pt == True 
    then 
      Svg.circle [cx (String.fromFloat pt.x), cy (String.fromFloat pt.y), r "7.5", fill "red"] []
    else
      Svg.circle [cx (String.fromFloat pt.x), cy (String.fromFloat pt.y), r "7.5", fill "green"]  [] 

pointstocircles : List (Point) -> List (Svg msg)
pointstocircles pts = 
  List.map pointtocircle pts

estimatePi : Model -> Float
estimatePi model =
  4* (toFloat model.hitCount / toFloat (model.missCount + model.hitCount))

view : Model -> Html Msg --Html takes one type arg, exactly same type as msg
view model =
    Html.node "div" []
        [Html.text ("estimate: " ++ Debug.toString (estimatePi model))
        , Html.node "div" [] 
        [Svg.svg [width "500", height "500", viewBox "0 0 500 500"] ((pointstocircles model.hits) ++ (pointstocircles model.misses))]]