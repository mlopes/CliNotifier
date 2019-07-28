{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module SlackService
    ( sendMessage
    , NotificationMessage(NotificationMessage)
    ) where

import Prelude hiding (concat, putStrLn)
import Data.Text
import Data.Text.IO
import Network.Linklater
import Network.Linklater.Types
import Control.Monad.Except
import Data.Time.Clock
import Data.String.Interpolate ( i )
import System.Exit

import ConfigLoader

data NotificationMessage =
  NotificationMessage {
      startTime :: UTCTime
    , endTime :: UTCTime
    , elapsedTime :: NominalDiffTime
    , cliCommand :: Text
    , exitCode :: ExitCode
  }

sendMessage :: ApplicationConfig -> NotificationMessage -> IO ()
sendMessage (ApplicationConfig hook) notificationMessage = do
  _ <- putStrLn(hook)
  messageResult <- publishMessage (Config hook) (buildMessage notificationMessage)
  case messageResult of
    Left e -> putStrLn ("An error occurred!" <> showText e)
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

