{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ExtendedDefaultRules #-}


module IpApp.Api.Root
    ( root
    ) where

import qualified Control.Monad.IO.Class as IO
import qualified Data.Time.Clock as Clock
import Servant
import qualified IpApp.IpInfo as IpInfo


root :: Handler IpInfo.IpInfo
root = do
    time <- IO.liftIO Clock.getCurrentTime
    return $ IpInfo.IpInfo time
