{-# LANGUAGE OverloadedStrings #-}

module Http.SlackClient
  ( notify
  ) where

import Network.HTTP.Req
import Data.Aeson
import Data.ByteString (ByteString)
import Data.Functor

notify :: ByteString -> IO ()
notify hook = call $ parseUrlHttps hook

call :: Maybe (Url a, Option b) -> IO ()
call Nothing = pure ()
call (Just u)  = (runReq defaultHttpConfig (request $ fst u)) <&> (\_ -> ())

request :: Url s -> Req IgnoreResponse
request url = req
  POST
  url
  (ReqBodyJson buildPayload)
  ignoreResponse
  mempty


buildPayload :: Value
buildPayload = object
    [ "foo" .= (10 :: Int)
    , "bar" .= (20 :: Int) ]
{-
   [
	{
		"type": "section",
		"text": {
			"type": "mrkdwn",
			"text": "*Finished running command triggered by <@ULFRW43KM>*"
		}
	},
	{
		"type": "divider"
	},
	{
		"type": "section",
		"text": {
			"type": "mrkdwn",
			"text": "*Command:*.\\test.py\n*Started At:* 2019-07-30 10:58:02.623789 UTC\n*Finished At:* 2019-07-30 10:58:07.702223 UTC\n*Duration:* 5.078434s\n*Exit Code:*  ExitSuccess"
		},
		"accessory": {
			"type": "image",
			"image_url": "https://api.slack.com/img/blocks/bkb_template_images/approvalsNewDevice.png",
			"alt_text": "computer thumbnail"
		}
	}
   ]
-}
