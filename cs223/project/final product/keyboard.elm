port module Keyboard exposing (main)

import Browser
import Browser.Events
import Json.Decode as Decode
import Json.Encode as Encode
import Html exposing (Html)
import Html.Attributes as Attr
import Set

--this code is modeled off of the count-button-clicks code we made in class

-- MODEL

type alias Note = Int

type alias Model = { freqs : Set.Set (Note), octave : Int, wavetype : String }

initModel = { freqs = Set.empty, octave = 4, wavetype = "square" }


-- UPDATE

type Msg = Noop | KeyDown Note | KeyUp Note | ChangeOctave Int | ChangeWavetype String

okoctave : Int -> Int
okoctave octave =
  if octave >= 0 then octave else 0

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Noop -> (model, Cmd.none)
    KeyDown pitch -> ({ model | freqs = Set.insert pitch model.freqs}, sendnote (Encode.int pitch))
    KeyUp pitch -> ({ model | freqs = Set.remove pitch model.freqs}, stopnote (Encode.int pitch))
    ChangeOctave oct -> ({ model | octave = (okoctave (model.octave + oct)) }, octavechange (Encode.int (okoctave (model.octave + oct))))
    ChangeWavetype wav -> ({ model | wavetype = wav }, sendwave (Encode.string wav))

-- PORTS

port sendnote : Encode.Value -> Cmd msg

port stopnote : Encode.Value -> Cmd msg

port octavechange : Encode.Value -> Cmd msg

port sendwave : Encode.Value -> Cmd msg


-- VIEW

stylemap : List (String, String) -> List (Html.Attribute Msg) 
stylemap s = (List.map (\(k, v) -> Attr.style k v) s)

inttokey : Int -> Int -> String
inttokey octave note =
  if ((note > 25) || (note < 1)) then "None"
  else 
    let 
      oct = String.fromInt(octave)
      oct1 = String.fromInt(octave+1)
      oct2 = String.fromInt(octave+2)
    in 
      if note == 1 then "C" ++ oct
      else if note == 2 then "C#" ++ oct
      else if note == 3 then "D" ++ oct
      else if note == 4 then "D#" ++ oct
      else if note == 5 then "E" ++ oct
      else if note == 6 then "F" ++ oct
      else if note == 7 then "F#" ++ oct
      else if note == 8 then "G" ++ oct
      else if note == 9 then "G#" ++ oct
      else if note == 10 then "A" ++ oct
      else if note == 11 then "A#" ++ oct
      else if note == 12 then "B" ++ oct
      else if note == 13 then "C" ++ oct1
      else if note == 14 then "C#" ++ oct1
      else if note == 15 then "D" ++ oct1
      else if note == 16 then "D#" ++ oct1
      else if note == 17 then "E" ++ oct1
      else if note == 18 then "F" ++ oct1
      else if note == 19 then "F#" ++ oct1
      else if note == 20 then "G" ++ oct1
      else if note == 21 then "G#" ++ oct1
      else if note == 22 then "A" ++ oct1
      else if note == 23 then "A#" ++ oct1
      else if note == 24 then "B" ++ oct1
      else if note == 25 then "C" ++ oct2
      else "None"



printfreqs : Model -> String
printfreqs model =
  if (Set.isEmpty model.freqs) then "None"
  else (String.join ", " (List.map (\x -> inttokey model.octave x) (Set.toList model.freqs)))


view : Model -> Html Msg
view model =
    let 
      freqstyle =
          [ ("position", "absolute") 
          , ("margin-top", "450px")
          ]
    
      instructions =
          [ ("position", "absolute")
          , ("margin-top", "500px")
          ]

      instructions1 =
          [ ("position", "absolute")
          , ("margin-top", "520px")
          ]

      instructions2 =
          [ ("position", "absolute")
          , ("margin-top", "540px")
          ]

      instructions3 =
          [ ("position", "absolute")
          , ("margin-top", "560px")
          ]

      instructions4 =
          [ ("position", "absolute")
          , ("margin-top", "580px")
          ]
    
      wrap =
          [ ("width", "1100px")
          , ("height", "350px")
          , ("background-color", "red")]
    
      whitekeyboxstyles = 
          [ ("width", "70px")
          , ("height", "300px")
          , ("float", "left")
          , ("margin-right", "1px")
          , ("margin-top", "25px")
          ]
    
      margin = 
          [ ("width", "14px")
          , ("height", "300px")
          , ("float", "left")
          , ("margin-right", "1px")
          , ("margin-top", "25px")
          , ("backgroundColor", "red")
          ]
    
      blackkeyboxstyles =
          [ ("width", "40px")
          , ("height", "200px")
          , ("float", "left")
          , ("position", "fixed")
          , ("margin-top", "25px")
          ]

      display = Html.text ("Base Octave: " ++ (Debug.toString model.octave) ++ ", Wave type:" ++ (Debug.toString model.wavetype) ++ ", Notes playing : " ++ (Debug.toString (printfreqs model))) 
    
      rules = Html.text ("Instructions:")

      rules1 = Html.text ("Keyboard is (in chromatic order): {z s x d c v g b h n j m ,}")

      rules2 = Html.text ("and then starting on the C an octave above: {q 2 w 3 e r 5 t 6 y 7 u i}") 

      rules3 = Html.text ("'o' shifts down an octave, 'p' shifts up an octave")
                          
      rules4 = Html.text ("[ changes the tone to a square wave, ] to sawtooth, ; to sine, ' to triangle")
    
      pitches = model.freqs
    
      whitecheck p n = if (Set.member n p) then (Attr.style "backgroundColor" "yellow") else (Attr.style "backgroundColor" "white")   
    
      blackcheck p n = if (Set.member n p) then (Attr.style "backgroundColor" "green") else (Attr.style "backgroundColor" "black")   
    
    in

    Html.div (stylemap wrap) 
      [Html.div []
        [ Html.div (stylemap freqstyle) [display]
        , Html.b (stylemap instructions) [rules]
        , Html.div (stylemap instructions1) [rules1]
        , Html.div (stylemap instructions2) [rules2]
        , Html.div (stylemap instructions3) [rules3]
        , Html.div (stylemap instructions4) [rules4]
        , Html.div (stylemap margin) []
        , Html.div ((whitecheck pitches 1) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 3) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 5) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 6) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 8) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 10) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 12) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 13) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 15) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 17) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 18) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 20) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 22) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 24) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((whitecheck pitches 25) :: (stylemap whitekeyboxstyles)) []
        , Html.div ((Attr.style "margin-left" "65px") :: ((blackcheck pitches 2) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "135px") :: ((blackcheck pitches 4) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "275px") :: ((blackcheck pitches 7) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "345px") :: ((blackcheck pitches 9) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "415px") :: ((blackcheck pitches 11) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "565px") :: ((blackcheck pitches 14) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "635px") :: ((blackcheck pitches 16) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "775px") :: ((blackcheck pitches 19) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "845px") :: ((blackcheck pitches 21) :: (stylemap blackkeyboxstyles))) []
        , Html.div ((Attr.style "margin-left" "915px") :: ((blackcheck pitches 23) :: (stylemap blackkeyboxstyles))) []
        ]
      ]


-- SUBSCRIPTIONS

keyDecoder : Decode.Decoder String
keyDecoder =
  Decode.field "key" Decode.string

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Browser.Events.onKeyUp
        (Decode.map 
                  (\key -> 
                    if key == "z" then KeyUp 1
                    else if key == "s" then KeyUp 2
                    else if key == "x" then KeyUp 3
                    else if key == "d" then KeyUp 4
                    else if key == "c" then KeyUp 5
                    else if key == "v" then KeyUp 6
                    else if key == "g" then KeyUp 7
                    else if key == "b" then KeyUp 8
                    else if key == "h" then KeyUp 9
                    else if key == "n" then KeyUp 10
                    else if key == "j" then KeyUp 11
                    else if key == "m" then KeyUp 12
                    else if key == "," then KeyUp 13
                    else if key == "q" then KeyUp 13
                    else if key == "2" then KeyUp 14
                    else if key == "w" then KeyUp 15
                    else if key == "3" then KeyUp 16
                    else if key == "e" then KeyUp 17
                    else if key == "r" then KeyUp 18
                    else if key == "5" then KeyUp 19
                    else if key == "t" then KeyUp 20
                    else if key == "6" then KeyUp 21
                    else if key == "y" then KeyUp 22
                    else if key == "7" then KeyUp 23
                    else if key == "u" then KeyUp 24
                    else if key == "i" then KeyUp 25
                    else Noop) keyDecoder)
    , Browser.Events.onKeyDown
        (Decode.map 
          (\key -> 
            if key == "z" then KeyDown 1
            else if key == "s" then KeyDown 2
            else if key == "x" then KeyDown 3
            else if key == "d" then KeyDown 4
            else if key == "c" then KeyDown 5
            else if key == "v" then KeyDown 6
            else if key == "g" then KeyDown 7
            else if key == "b" then KeyDown 8
            else if key == "h" then KeyDown 9
            else if key == "n" then KeyDown 10
            else if key == "j" then KeyDown 11
            else if key == "m" then KeyDown 12
            else if key == "," then KeyDown 13
            else if key == "q" then KeyDown 13
            else if key == "2" then KeyDown 14
            else if key == "w" then KeyDown 15
            else if key == "3" then KeyDown 16
            else if key == "e" then KeyDown 17
            else if key == "r" then KeyDown 18
            else if key == "5" then KeyDown 19
            else if key == "t" then KeyDown 20
            else if key == "6" then KeyDown 21
            else if key == "y" then KeyDown 22
            else if key == "7" then KeyDown 23
            else if key == "u" then KeyDown 24
            else if key == "i" then KeyDown 25
            else if key == "p" then ChangeOctave 1
            else if key == "o" then ChangeOctave (-1)
            else if key == "[" then ChangeWavetype "square"
            else if key == "]" then ChangeWavetype "sawtooth"
            else if key == ";" then ChangeWavetype "sine"
            else if key == "'" then ChangeWavetype "triangle"
            else Noop) keyDecoder)
    ]


-- MAIN

type alias Flags = ()

init : Flags -> (Model, Cmd Msg)
init () = (initModel, Cmd.none)

main : Program Flags Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }