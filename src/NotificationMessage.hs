module NotificationMessage
  ( NotificationMessage(..)
  ) where

import Data.Text
import Data.Time.Clock
import System.Exit

type User = Text

data NotificationMessage =
  NotificationMessage
    { user :: User
    , startTime :: UTCTime
    , endTime :: UTCTime
    , elapsedTime :: NominalDiffTime
    , cliCommand :: Text
    , exitCode :: ExitCode
    }
