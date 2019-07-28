{-# LANGUAGE OverloadedStrings #-}

module Main where

import Prelude hiding (putStrLn)
import Data.Text
import Data.Text.IO
import System.Environment
import System.Directory
import System.FilePath

import SlackService
import CommandRunner
import ConfigLoader

main :: IO ()
main = do
  args <- getArgs
  outcome <- run $ fmap pack args
  case outcome of
    Failure errorMessage -> putStrLn(errorMessage)
    Success startTime endTime elapsedTime exitCode command -> do
      home <- getHomeDirectory
      let path = pack $ home </> (unpack ".config/CliNotifier/config")
      config <- load path
      let messageDispatcher = sendMessage config
      dispatchResult <- messageDispatcher $ NotificationMessage startTime endTime elapsedTime command exitCode
      return dispatchResult

