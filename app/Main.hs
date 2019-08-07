{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import Prelude hiding (putStrLn)
import Data.Text
import Data.Text.IO
import Data.String.Interpolate ( i )
import System.Environment
import System.Directory
import System.FilePath

import Http.SlackClient
import CommandRunner
import ConfigLoader
import NotificationMessage (NotificationMessage(NotificationMessage))

main :: IO ()
main = do
  args <- getArgs
  outcome <- run $ fmap pack args
  case outcome of
    Failure errorMessage -> putStrLn errorMessage
    Success startTime endTime elapsedTime command exitCode -> do
      home <- getHomeDirectory
      let path = pack $ home </> unpack ".config/CliNotifier/config"
      config <- loadConfigFrom path
      case config of
        LoadingFailure e -> putStrLn [i|Failed to parse configuration file with error #{e}.|]
        LoadedConfig hook user -> do
          let messageDispatcher = notify hook
          messageDispatcher $ NotificationMessage user startTime endTime elapsedTime command exitCode

