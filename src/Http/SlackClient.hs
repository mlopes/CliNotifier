{-# LANGUAGE OverloadedStrings #-}

module Http.SlackClient
  ( notify
  ) where

import Network.HTTP.Req
import Data.Text
import Data.Aeson
import Data.ByteString (ByteString)
import Data.Functor

notify :: ByteString -> IO ()
notify hook = call $ parseUrlHttps hook

call :: Maybe (Url a, Option b) -> IO ()
call Nothing = pure ()
call (Just u)  = do
  _ <- print (encode buildPayload)
  r <- (runReq defaultHttpConfig (request $ fst u)) <&> (\_ -> ())
  return r

request :: Url s -> Req IgnoreResponse
request url = req
  POST
  url
  (ReqBodyJson buildPayload)
  ignoreResponse
  mempty


buildPayload :: Value
buildPayload = object [ "attachments" .= [ object [ "fallback" .= ("Finished running command." :: Text) , "color" .= ("#36a64f" :: Text) , "pretext" .= ("Finished running command triggered by <@ULFRW43KM>" :: Text) , "title" .= ("Command Execution Details" :: Text) , "text" .= ("./test.py" :: Text) , "fields" .= [ object [ "title" .= ("Started At" :: Text), "value" .= ("2019-07-30 10:58:02.623789 UTC" :: Text), "short" .= (False :: Bool) ] , object [ "title" .= ("Finished At" :: Text), "value" .= ("2019-07-30 10:58:07.702223 UTC" :: Text), "short" .= (False :: Bool) ] , object [ "title" .= ("Duration" :: Text), "value" .= ("5.078434s" :: Text), "short" .= (False :: Bool) ] , object [ "title" .= ("Exit Code" :: Text), "value" .= ("ExitSuccess" :: Text), "short" .= (False :: Bool) ] ] ] ] ]
  --object [
    --"type" .= ("section" :: Text)
    --, "text" .= object [ "type" .= ("mrkdwn" :: Text) , "text" .= ("*Finished running command triggered by <@ULFRW43KM>*" :: Text) ] ] , object [ "type" .= ("divider" :: Text) ] , object [ "type" .= ("section" :: Text) , "text" .= object [ "type" .= ("mrkdwn" :: Text) , "text" .= ("*Command:*.\\test.py\n*Started At:* 2019-07-30 10:58:02.623789 UTC\n*Finished At:* 2019-07-30 10:58:07.702223 UTC\n*Duration:* 5.078434s\n*Exit Code:* ExitSuccess" :: Text) ] , "accessory" .= object [ "type" .= ("image" :: Text) , "image_url" .= ("https://api.slack.com/img/blocks/bkb_template_images/approvalsNewDevice.png" :: Text) , "alt_text" .= ("computer thumbnail" :: Text) ] ] ]

{-
{
    "attachments": [
        {
            "fallback": "Finished running command.",
            "color": "#36a64f",
            "pretext": "Finished running command triggered by <@ULFRW43KM>",
            "title": "Command Execution Details",
            "text": "./test.py",
            "fields": [
                {
                    "title": "Started At",
                    "value": "2019-07-30 10:58:02.623789 UTC",
                    "short": false
                },
				{
					"title": "Finished At",
                    "value": "2019-07-30 10:58:07.702223 UTC",
                    "short": false
				},
				{
					"title": "Duration",
					"value": "5.078434s",
                    "short": false
				},
				{
					"title": "Exit Code",
					"value": "ExitSuccess",
                    "short": false
				}
            ]
        }
    ]
}
-}

