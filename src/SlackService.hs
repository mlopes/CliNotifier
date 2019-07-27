{-# LANGUAGE OverloadedStrings #-}

module SlackService
    ( sendMessage
    , NotificationMessage(NotificationMessage)
    , Hook
    ) where

import Prelude hiding (concat)
import Data.Text
import Network.Linklater
import Network.Linklater.Types
import Control.Monad.Except
import Data.Time.Clock

type Hook = Text

data NotificationMessage =
  NotificationMessage {
      startTime :: UTCTime
    , endTime :: UTCTime
    , elapsedTime :: NominalDiffTime
    , cliCommand :: Text
  }

sendMessage :: Hook -> NotificationMessage -> IO ()
sendMessage hook notificationMessage = do
  messageResult <- publishMessage (Config hook) (buildMessage notificationMessage)
  case messageResult of
    Left e -> putStrLn ("An error occurred!" <> show e)
    Right _ -> return ()


buildMessage :: NotificationMessage -> Text
buildMessage m = concat ["`", cliCommand m, "` started at: ", pack $ show $ startTime m, " finished at: ", pack $ show $ endTime m, " ran for : ", pack $ show $ elapsedTime m , "."]

publishMessage :: Config -> Text -> IO (Either RequestError ())
publishMessage config text = runExceptT $ say (message text) config

message :: Text -> Message
message = SimpleMessage (icon) "CliNotifier" channel

channel :: Channel
channel = Channel "" ""

icon :: Icon
icon = EmojiIcon ":computer:"

