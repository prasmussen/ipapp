{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ExtendedDefaultRules #-}


module IpApp.Api.Root
    ( root
    ) where


import Servant
import qualified IpApp.IpInfo as IpInfo
import qualified IpApp.RemoteIp as RemoteIp
import qualified IpApp.Config as Config
import qualified Network.Socket as Socket


root :: Config.Config -> Socket.SockAddr -> Maybe RemoteIp.RealIpHeader -> Handler IpInfo.IpInfo
root config socket ipHeader =
    let
        ipSource =
            Config.remoteIpSource config

        remoteIp =
            RemoteIp.getRemoteIp ipSource socket ipHeader
    in
    return $ IpInfo.fromRemoteIp remoteIp
