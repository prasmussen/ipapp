module Main where

import qualified Network.Wai.Handler.Warp as Warp
import qualified Safe
import qualified Data.Text as T
import qualified System.Environment as Env
import qualified Data.Coerce as Coerce
import qualified IpApp.Config as Config
import qualified IpApp.Api as Api
import qualified IpApp.RemoteIp as RemoteIp
import Data.Function ((&))
import Data.Monoid ((<>))


main :: IO ()
main = do
    listenPort <- lookupSetting "LISTEN_PORT" (Config.ListenPort 8081)
    listenHost <- lookupSetting "LISTEN_HOST" (Config.ListenHost "*4")
    config <- readConfig
    print listenHost
    print listenPort
    Warp.runSettings (warpSettings listenPort listenHost) (Api.app config)


readConfig :: IO Config.Config
readConfig = do
    staticPath <- lookupSetting "STATIC_PATH" (Config.StaticPath "./static")
    ipSource <- lookupSetting "IP_SOURCE" RemoteIp.Socket
    return $ Config.Config
        { Config.staticPath = staticPath
        , Config.remoteIpSource = ipSource
        }

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
