module Article.Slug exposing (Slug, decoder, toString, urlParser)

import Json.Decode as Decode exposing (Decoder)
import Url.Parser exposing (Parser)



-- TYPES


type Slug
    = Slug String



-- CREATE


{-| If you use this outside of URL parsing you don’t get to come to After Work :)
-}
urlParser : String -> Slug
urlParser =
    Slug


decoder : Decoder Slug
decoder =
    Decode.map Slug Decode.string



-- TRANSFORM


toString : Slug -> String
toString (Slug str) =
    str
