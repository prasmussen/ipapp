{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ExtendedDefaultRules #-}


module IpApp.Api.Root
    ( root
    ) where

import qualified Control.Monad.IO.Class as IO
import qualified Data.Time.Clock as Clock
import Servant
import qualified IpApp.IpInfo as IpInfo
import qualified IpApp.RemoteIp as RemoteIp
import qualified Network.Socket as Socket


root :: Socket.SockAddr -> Maybe RemoteIp.RealIpHeader -> Handler IpInfo.IpInfo
root socket ipHeader = do
    return $ IpInfo.IpInfo (RemoteIp.formatIp socket)
