{-# LANGUAGE OverloadedStrings #-}

module Main where

import SlackService
import Data.Time.Clock

main :: IO ()
main = do
  startTime <- getCurrentTime
  let message = "ls -lha"
  let messageDispatcher = sendMessage "https://hooks.slack.com/services/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"
  endTime <- getCurrentTime
  let elapsedTime = diffUTCTime endTime startTime
  _ <- messageDispatcher $ NotificationMessage startTime endTime elapsedTime message
  return ()
