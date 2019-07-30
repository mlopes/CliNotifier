{-# LANGUAGE OverloadedStrings #-}

module CommandRunner
    ( run
    , Outcome(Failure, Success)
    ) where

import Data.Text
import Data.Time.Clock
import System.Process
import System.Exit

type ErrorMessage = Text
type Command = Text
data Outcome = Success UTCTime UTCTime NominalDiffTime Command ExitCode | Failure ErrorMessage

run :: [Text] -> IO Outcome
run args = do
  startTime <- getCurrentTime
  case (args) of
    [] -> return $ Failure "You need to specify a command to run"
    argList -> do
      let command = intercalate " " argList
      exitCode <-  system $ unpack command
      endTime <- getCurrentTime
      let elapsedTime = diffUTCTime endTime startTime
      return $ Success startTime endTime elapsedTime command exitCode

