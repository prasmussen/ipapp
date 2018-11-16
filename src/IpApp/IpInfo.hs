module IpApp.IpInfo
    ( IpInfo(..)
    , getIp
    ) where


import qualified Data.Time.Clock as Clock
import qualified Data.Time.Calendar as Calendar
import qualified Data.Time.Calendar.WeekDate as WeekDate
import qualified Data.ByteString.Lazy.Char8 as BSL8
import qualified Data.Aeson as Aeson
import qualified Servant
import Data.Monoid ((<>))
import Lucid
import Data.Aeson ((.=))



newtype IpInfo = IpInfo Clock.UTCTime
    deriving (Show)


instance ToHtml IpInfo where
    toHtml ipInfo =
        let
            ip =
                toHtml $ show $ getIp ipInfo
        in
        doctypehtml_ $ do
            head_ $ do
                meta_ [ charset_ "UTF-8" ]
                meta_ [ name_ "viewport", content_ "width=device-width, initial-scale=1, shrink-to-fit=no" ]
                title_ ("Ip: " <> ip)
                link_ [ rel_ "stylesheet", type_ "text/css", href_ "/static/styles.css" ]
            body_ $ do
                div_ [ class_ "ip" ] ("Ip: " <> ip)
                div_ [ class_ "api" ] $ do
                    h3_ "API"
                    p_ "Plaintext: curl https://ip.vevapp.no"
                    p_ "JSON: curl https://ip.vevapp.no --header \"Accept: application/json\""

    toHtmlRaw =
        toHtml


instance Aeson.ToJSON IpInfo where
    toJSON ipInfo =
        Aeson.object
            [ "ip" .= getIp ipInfo
            ]


instance Servant.MimeRender Servant.PlainText IpInfo where
    mimeRender _ ipInfo =
        BSL8.pack $ show $ getIp ipInfo


getIp :: IpInfo -> Int
getIp (IpInfo time) =
    weekOfYear
    where
        day =
            Clock.utctDay time

        (_, weekOfYear, _) =
            WeekDate.toWeekDate day
