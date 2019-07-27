{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( slackResult
    ) where

import Network.Linklater
import Network.Linklater.Types
import Control.Monad.Except

slackResult :: IO ()
slackResult = do
  messageResult <- sendMessage
  case messageResult of
    Left e -> putStrLn ("An error occurred!" <> show e)
    Right _ -> return ()

sendMessage :: IO (Either RequestError ())
sendMessage = runExceptT $ say message config

config :: Config
config = Config "https://hooks.slack.com/services/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"

message :: Message
message = SimpleMessage (icon) "Some Bot" channel "Some more text"

channel :: Channel
channel = Channel "" ""

icon :: Icon
icon = EmojiIcon "computer"

