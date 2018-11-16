{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}


module IpApp.Api
    ( app
    ) where


import qualified IpApp.Api.Routes as Routes
import qualified IpApp.Config as Config
import qualified Servant


type AppAPI
    = Routes.Api


appApi :: Servant.Proxy AppAPI
appApi =
    Servant.Proxy


appServer :: Config.Config -> Servant.Server AppAPI
appServer config =
    Routes.server config


app :: Config.Config -> Servant.Application
app config =
    Servant.serve appApi (appServer config)