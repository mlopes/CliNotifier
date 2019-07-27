{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Time.Clock
import Data.Text
import System.Environment
import SlackService

main :: IO ()
main = do
  startTime <- getCurrentTime
  args <- getArgs
  case (fmap pack args) of
    [] -> putStrLn("Missing command to notify on.")
    cliCommand:cliCommandParameters -> processMessage cliCommand startTime
  return ()

processMessage :: Text -> UTCTime -> IO ()
processMessage cliCommand startTime = do
  let messageDispatcher = sendMessage "https://hooks.slack.com/services/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"
  endTime <- getCurrentTime
  let elapsedTime = diffUTCTime endTime startTime
  _ <- messageDispatcher $ NotificationMessage startTime endTime elapsedTime cliCommand
  return ()

