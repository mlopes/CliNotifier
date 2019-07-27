{-# LANGUAGE OverloadedStrings #-}

module SlackService
    ( sendMessage
    , Hook
    ) where

import Data.Text
import Network.Linklater
import Network.Linklater.Types
import Control.Monad.Except

type Hook = Text

sendMessage :: Hook -> IO ()
sendMessage hook = do
  messageResult <- publishMessage $ Config hook
  case messageResult of
    Left e -> putStrLn ("An error occurred!" <> show e)
    Right _ -> return ()

publishMessage :: Config -> IO (Either RequestError ())
publishMessage config = runExceptT $ say message config

message :: Message
message = SimpleMessage (icon) "Some Bot" channel "Some more text"

channel :: Channel
channel = Channel "" ""

icon :: Icon
icon = EmojiIcon ":computer:"

