{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Time.Clock
import Data.Text
import System.Environment
import System.Process
import SlackService

main :: IO ()
main = do
  startTime <- getCurrentTime
  args <- getArgs
  case (fmap pack args) of
    [] -> putStrLn("Missing command to notify on.")
    cliCommand:cliCommandParameters -> processMessage cliCommand cliCommandParameters startTime
  return ()

processMessage :: Text -> [Text] -> UTCTime -> IO ()
processMessage cliCommand cliCommandParameters startTime = do
  let messageDispatcher = sendMessage "https://hooks.slack.com/services/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"
  -- Executre command here
  -- (_, Just hout, _, _) <- createProcess (proc "./test.py" []){ std_out = CreatePipe }
  let  cmdText = intercalate " " (cliCommand:cliCommandParameters)
  exitCode <-  system $ unpack cmdText
  endTime <- getCurrentTime
  let elapsedTime = diffUTCTime endTime startTime
  _ <- messageDispatcher $ NotificationMessage startTime endTime elapsedTime cmdText
  return ()

