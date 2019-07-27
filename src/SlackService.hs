{-# LANGUAGE OverloadedStrings #-}

module SlackService
    ( sendMessage
    , Hook
    ) where

import Prelude hiding (concat)
import Data.Text
import Network.Linklater
import Network.Linklater.Types
import Control.Monad.Except
import Data.Time.Clock

type Hook = Text

sendMessage :: Hook -> UTCTime -> UTCTime -> NominalDiffTime -> Text -> IO ()
sendMessage hook startTime endTime elapsedTime cliCommand = do
  messageResult <- publishMessage (Config hook) (buildMessage startTime endTime elapsedTime cliCommand)
  case messageResult of
    Left e -> putStrLn ("An error occurred!" <> show e)
    Right _ -> return ()


buildMessage :: UTCTime -> UTCTime -> NominalDiffTime -> Text -> Text
buildMessage startTime endTime elapsedTime cliCommand = concat ["`", cliCommand, "` started at: ", pack $ show startTime, " finished at: ", pack $ show endTime, " ran for : ", pack $ show elapsedTime, "."]

publishMessage :: Config -> Text -> IO (Either RequestError ())
publishMessage config text = runExceptT $ say (message text) config

message :: Text -> Message
message = SimpleMessage (icon) "Some Bot" channel

channel :: Channel
channel = Channel "" ""

icon :: Icon
icon = EmojiIcon ":computer:"

