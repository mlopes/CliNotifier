{-# LANGUAGE OverloadedStrings #-}

module ConfigLoader
    ( loadConfigFrom
    , LoadedConfig(LoadedConfig, LoadingFailure)
    ) where

import Prelude hiding (readFile)
import Data.Text
import Data.Text.IO
import Data.Text.Encoding
import Data.ByteString (ByteString)
import qualified Data.Yaml as Y
import Data.Yaml (FromJSON(..), (.:))

data ConfigFormat  = ConfigFormat {
    user :: Text
  , hook :: ByteString
} deriving Show

instance FromJSON ByteString where
  parseJSON = Y.withText "ByteString" $ pure . encodeUtf8

instance FromJSON ConfigFormat where
  parseJSON = Y.withObject "ConfigFormat" $ \v -> ConfigFormat
    <$> v .: "user"
    <*> v .: "hook"

type Hook = ByteString
type User = Text
data LoadedConfig = LoadedConfig Hook User | LoadingFailure Text

loadConfigFrom :: Text -> IO LoadedConfig
loadConfigFrom configPath = do
  c <- configFromFile configPath
  return (case (c) of
      Left e -> LoadingFailure $ pack $ Y.prettyPrintParseException e
      Right config -> LoadedConfig (hook config) (user config))

readFileWithName :: Text -> IO Text
readFileWithName fileName = fmap strip (readFile $ unpack fileName)

configFromFile :: Text -> IO (Either Y.ParseException ConfigFormat)
configFromFile file =
  Y.decodeFileEither $ unpack file :: IO(Either Y.ParseException ConfigFormat)

