{-# LANGUAGE OverloadedStrings #-}

module ConfigLoader
    ( load
    , ApplicationConfig(ApplicationConfig)
    , Hook
    ) where

import Prelude hiding (readFile)
import Data.Text
import Data.Text.IO

type Hook = Text
data ApplicationConfig = ApplicationConfig Hook

load :: Text -> IO ApplicationConfig
load configPath = fmap ApplicationConfig (readFileWithName configPath)

readFileWithName :: Text -> IO Text
readFileWithName fileName = fmap strip (readFile $ unpack fileName)

