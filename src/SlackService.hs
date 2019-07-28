{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

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
import Data.String.Interpolate ( i )
import System.Exit

type Hook = Text

data NotificationMessage =
  NotificationMessage {
      startTime :: UTCTime
    , endTime :: UTCTime
    , elapsedTime :: NominalDiffTime
    , cliCommand :: Text
    , exitCode :: ExitCode
  }

sendMessage :: Hook -> NotificationMessage -> IO ()
sendMessage hook notificationMessage = do
  messageResult <- publishMessage (Config hook) (buildMessage notificationMessage)
  case messageResult of
    Left e -> putStrLn ("An error occurred!" <> show e)
    Right _ -> return ()


buildMessage :: NotificationMessage -> Text
buildMessage m = intercalate "\n" [
                      [i|command: #{cliCommand m}|]
                    , [i|started at: #{showText $ startTime m}|]
                    , [i|finished at: #{showText $ endTime m}|]
                    , [i|ran for: #{showText $ elapsedTime m}|]
                    , [i|exit code: #{showText $ exitCode m}|]]

publishMessage :: Config -> Text -> IO (Either RequestError ())
publishMessage config text = runExceptT $ say (message text) config

message :: Text -> Message
message = SimpleMessage (icon) "CliNotifier" channel

channel :: Channel
channel = Channel "" ""

icon :: Icon
icon = EmojiIcon ":computer:"

showText :: Show a => a -> Text
showText = pack . show

