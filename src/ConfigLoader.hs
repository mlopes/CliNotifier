{-# LANGUAGE OverloadedStrings #-}

module ConfigLoader
    ( load
    , LoadedConfig(LoadedConfig, LoadingFailure)
    , Hook
    ) where

import Prelude hiding (readFile)
import Data.Text
import Data.Text.IO
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:), withObject)

data ConfigFormat  = ConfigFormat {
    user :: Text
  , hook :: Text
} deriving Show

instance FromJSON ConfigFormat where
  parseJSON = withObject "ConfigFormat" $ \v -> ConfigFormat
    <$> v .: "user"
    <*> v .: "hook"

type Hook = Text
type User = Text
data LoadedConfig = LoadedConfig Hook User | LoadingFailure Text

load :: Text -> IO LoadedConfig
load configPath = do
  c <- configFromFile configPath
  return (case (c) of
      Left e -> LoadingFailure $ pack $ Y.prettyPrintParseException e
      Right config -> LoadedConfig (hook config) (user config))

readFileWithName :: Text -> IO Text
readFileWithName fileName = fmap strip (readFile $ unpack fileName)

configFromFile :: Text -> IO (Either Y.ParseException ConfigFormat)
configFromFile file =
  Y.decodeFileEither $ unpack file :: IO(Either Y.ParseException ConfigFormat)

