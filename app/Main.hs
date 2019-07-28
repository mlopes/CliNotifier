{-# LANGUAGE OverloadedStrings #-}

module Main where

import Prelude hiding (putStrLn)
import Data.Time.Clock
import Data.Text
import Data.Text.IO
import System.Environment
import System.Process

import SlackService
import CommandRunner

main :: IO ()
main = do
  startTime <- getCurrentTime
  args <- getArgs
  outcome <- run $ fmap pack args
  case outcome of
    Failure errorMessage -> putStrLn(errorMessage)
    Success startTime endTime elapsedTime exitCode command -> do
      let messageDispatcher = sendMessage "https://hooks.slack.com/services/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"
      dispatchResult <- messageDispatcher $ NotificationMessage startTime endTime elapsedTime command exitCode
      return dispatchResult

