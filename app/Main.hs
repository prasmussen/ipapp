module Main where

import qualified Network.Wai.Handler.Warp as Warp
import qualified Safe
import qualified Data.Text as T
import qualified System.Environment as Env
import qualified Data.Coerce as Coerce
import qualified IpApp.Config as Config
import qualified IpApp.Api as Api
import Data.Function ((&))
import Data.Monoid ((<>))


main :: IO ()
main = do
    listenPort <- lookupSetting "LISTEN_PORT" (Config.ListenPort 8081)
    listenHost <- lookupSetting "LISTEN_HOST" (Config.ListenHost "*4")
    staticPath <- lookupSetting "STATIC_PATH" (Config.StaticPath "./static")
    let config = Config.Config { Config.staticPath = staticPath }
    print listenHost
    print listenPort
    (Warp.runSettings (warpSettings listenPort listenHost) (Api.app config))


warpSettings :: Config.ListenPort -> Config.ListenHost -> Warp.Settings
warpSettings (Config.ListenPort port) (Config.ListenHost host) =
    Warp.defaultSettings
    & Warp.setHost host
    & Warp.setPort port



lookupSetting :: Read a => String -> a -> IO a
lookupSetting envKey def = do
    maybeValue <- Env.lookupEnv envKey
    case maybeValue of
        Just str ->
            return $ readSetting envKey str

        Nothing ->
            return def


readSetting :: Read a => String -> String -> a
readSetting envKey str =
    case Safe.readMay str of
        Just value ->
            value

        Nothing ->
            error $ mconcat
                [ "«"
                , str
                , "» is not a valid value for the environment variable "
                , envKey
                ]
