module Username exposing (Username, decoder, encode, toHtml, toString, urlParser)

import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Url.Parser



-- TYPES


type Username
    = Username String



-- CREATE


decoder : Decoder Username
decoder =
    Decode.map Username Decode.string



-- TRANSFORM


encode : Username -> Value
encode (Username username) =
    Encode.string username


toString : Username -> String
toString (Username username) =
    username


{-| If you use this outside of URL parsing you don’t get to come to After Work :)
-}
urlParser : String -> Username
urlParser =
    Username


toHtml : Username -> Html msg
toHtml (Username username) =
    Html.text username
