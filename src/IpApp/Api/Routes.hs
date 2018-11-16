{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module IpApp.Api.Routes
    ( Api
    , server
    ) where

import qualified IpApp.Api.Root as Root
import qualified IpApp.IpInfo as IpInfo
import qualified IpApp.Config as Config
import qualified IpApp.RemoteIp as RemoteIp
import Servant
import Servant.HTML.Lucid



type Api
      =  RootRoute
    :<|> StaticRoute


server :: Config.Config -> Server Api
server config
      =  Root.root
    :<|> serveDirectoryWebApp (Config.staticPathStr config)


type RootRoute =
    RemoteHost
    :> Header "X-Real-Ip" RemoteIp.RealIpHeader
    :> Get '[PlainText, JSON, HTML] IpInfo.IpInfo


type StaticRoute =
    "static"
    :> Raw
