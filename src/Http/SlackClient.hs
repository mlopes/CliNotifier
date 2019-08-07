{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Http.SlackClient
  ( notify
  ) where

import Data.Aeson
import Data.ByteString (ByteString)
import Data.Functor
import Data.String.Interpolate (i)
import Data.Text
import Data.Time.Clock
import Network.HTTP.Req
import System.Exit

import NotificationMessage

notify :: ByteString -> NotificationMessage -> IO ()
notify hook message =
  call (parseUrlHttps hook) (ReqBodyJson $ buildPayload message)

call :: ToJSON r => Maybe (Url a, Option b) -> ReqBodyJson r -> IO ()
call Nothing _ = pure ()
call (Just u) reqBody = do
  let url = fst u
  runReq defaultHttpConfig (request url reqBody) $> ()

request :: ToJSON a => Url s -> ReqBodyJson a -> Req IgnoreResponse
request url reqBodyJson = req POST url reqBodyJson ignoreResponse mempty

buildPayload :: NotificationMessage -> Value
buildPayload message = object ["attachments" .= attachments message]

attachments :: NotificationMessage -> [Value]
attachments message =
  [ object
      [ "fallback" .= ("Finished running command." :: Text)
      , "color" .= colour (exitCode message)
      , "pretext" .=
        ([i|Finished running command triggered by <#{user message}>|] :: Text)
      , "title" .= ("Command Execution Details" :: Text)
      , "text" .= (cliCommand message :: Text)
      , "fields" .=
        fields
          (startTime message)
          (endTime message)
          (elapsedTime message)
          (exitCode message)
      ]
  ]

fields :: UTCTime -> UTCTime -> NominalDiffTime -> ExitCode -> [Value]
fields startTime endTime duration exitCode =
  [ field "Started At" startTime
  , field "Finished At" endTime
  , field "Duration" duration
  , field "Exit Code" exitCode
  ]

field :: ToJSON a => Text -> a -> Value
field title value =
  object ["title" .= title, "value" .= value, "short" .= False]

colour :: ExitCode -> Text
colour ExitSuccess = "#36a64f"
colour _ = "#a63636"

instance ToJSON ExitCode where
  toJSON = String . showText

showText :: Show a => a -> Text
showText = pack . show
