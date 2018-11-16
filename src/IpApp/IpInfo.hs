module IpApp.IpInfo
    ( IpInfo(..)
    ) where


import qualified Data.Time.Clock as Clock
import qualified Data.Time.Calendar as Calendar
import qualified Data.Time.Calendar.WeekDate as WeekDate
import qualified Data.ByteString.Lazy as BSL
import qualified Data.Text.Encoding as TE
import qualified Data.Aeson as Aeson
import qualified Data.Text as T
import qualified Servant
import Data.Monoid ((<>))
import Lucid
import Data.Aeson ((.=))



newtype IpInfo = IpInfo T.Text
    deriving (Show)


instance ToHtml IpInfo where
    toHtml (IpInfo ip) =
        let
            ipHtml =
                toHtml $ ip
        in
        doctypehtml_ $ do
            head_ $ do
                meta_ [ charset_ "UTF-8" ]
                meta_ [ name_ "viewport", content_ "width=device-width, initial-scale=1, shrink-to-fit=no" ]
                title_ ("Ip: " <> ipHtml)
                link_ [ rel_ "stylesheet", type_ "text/css", href_ "/static/styles.css" ]
            body_ $ do
                div_ [ class_ "ip" ] ("Ip: " <> ipHtml)
                div_ [ class_ "api" ] $ do
                    h3_ "API"
                    p_ "Plaintext: curl https://ip.vevapp.no"
                    p_ "JSON: curl https://ip.vevapp.no --header \"Accept: application/json\""

    toHtmlRaw =
        toHtml


instance Aeson.ToJSON IpInfo where
    toJSON (IpInfo ip) =
        Aeson.object
            [ "ip" .= ip
            ]


instance Servant.MimeRender Servant.PlainText IpInfo where
    mimeRender _ (IpInfo ip) =
        BSL.fromStrict $ TE.encodeUtf8 ip

