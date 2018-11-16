module IpApp.RemoteIp
    ( RemoteIp(..)
    , RealIpHeader(..)
    , formatIp
    ) where

import qualified Data.Text as T
import qualified GHC.Generics as GHC
import qualified Web.HttpApiData as HttpApiData
import qualified Network.Socket as Socket
import qualified Data.IP as IP


newtype RemoteIp = RemoteIp T.Text
    deriving (Show, GHC.Generic)


newtype RealIpHeader = RealIpHeader T.Text
    deriving (Show, GHC.Generic)


instance HttpApiData.FromHttpApiData RealIpHeader where
    parseUrlPiece text = Right $ RealIpHeader text



formatIp :: Socket.SockAddr -> T.Text
formatIp sockAddr =
    case sockAddr of
        Socket.SockAddrInet _ hostAddr ->
            T.pack $ show $ IP.fromHostAddress hostAddr

        Socket.SockAddrInet6 _ _ hostAddr6 _ ->
            T.pack $ show $ IP.fromHostAddress6 hostAddr6

        _ ->
            "N/A"