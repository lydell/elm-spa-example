module Route exposing (Route(..), fromUrl, href, replaceUrl)

import Article.Slug as Slug exposing (Slug)
import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Profile exposing (Profile)
import Url exposing (Url)
import Username exposing (Username)



-- ROUTING


type Route
    = Home
    | Root
    | Login
    | Logout
    | Register
    | Settings
    | Article Slug
    | Profile Username
    | NewArticle
    | EditArticle Slug


{-| Copied from elm/url.

In an alternate world, the Url type could look like:

    type alias Url =
        { protocol : Protocol
        , host : String
        , port_ : Maybe Int
        , path : List String -- Instead of just String (run `preparePath` on it)
        , query : Dict String (List String) -- Instead of Maybe String (run `prepareQuery` from elm/url on it)
        , fragment : Maybe String
        }

Paired with a helper function for easily getting a query parameter out of `Dict
String (List String)`, that’s all you need to parse urls.

-}
preparePath : String -> List String
preparePath path =
    case String.split "/" path of
        "" :: segments ->
            removeFinalEmpty segments

        segments ->
            removeFinalEmpty segments


removeFinalEmpty : List String -> List String
removeFinalEmpty segments =
    case segments of
        [] ->
            []

        "" :: [] ->
            []

        segment :: rest ->
            segment :: removeFinalEmpty rest


parser : String -> Maybe Route
parser path =
    case preparePath path of
        [] ->
            Just Home

        [ "login" ] ->
            Just Login

        [ "logout" ] ->
            Just Logout

        [ "settings" ] ->
            Just Settings

        [ "profile", username ] ->
            Just (Profile (Username.urlParser username))

        [ "register" ] ->
            Just Register

        [ "article", slug ] ->
            Just (Article (Slug.urlParser slug))

        [ "editor" ] ->
            Just NewArticle

        [ "editor", slug ] ->
            Just (EditArticle (Slug.urlParser slug))

        _ ->
            Nothing



-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    url.fragment
        |> Maybe.withDefault ""
        |> parser



-- INTERNAL


routeToString : Route -> String
routeToString page =
    "#/" ++ String.join "/" (routeToPieces page)


routeToPieces : Route -> List String
routeToPieces page =
    case page of
        Home ->
            []

        Root ->
            []

        Login ->
            [ "login" ]

        Logout ->
            [ "logout" ]

        Register ->
            [ "register" ]

        Settings ->
            [ "settings" ]

        Article slug ->
            [ "article", Slug.toString slug ]

        Profile username ->
            [ "profile", Username.toString username ]

        NewArticle ->
            [ "editor" ]

        EditArticle slug ->
            [ "editor", Slug.toString slug ]
