module Main where

import Happstack.Server
import Control.Exception (try)
import Data.Aeson (encodeFile, decode, decodeFileStrict)
import Data.Either (fromRight, fromLeft)
import Data.IORef (newIORef, readIORef, writeIORef)
import Data.Maybe (fromMaybe)
import Routes

conf = Conf {
  port = 3000,
  validator = Nothing,
  timeout = 1000,
  logAccess = Just logMAccess,
  threadGroup = Nothing
}

dataFileName = "data.json"

main :: IO ()
main = do
  putStrLn "turned on"
  writeIfFileDoesNotExist dataFileName "[]"
  items <- fromMaybe [] <$> decodeFileStrict dataFileName
  itemsRef <- newIORef items
  simpleHTTP conf $ routes (readIORef itemsRef) (createWriteItems itemsRef)

createWriteItems ref items = do
  writeIORef ref items
  encodeFile dataFileName items

writeIfFileDoesNotExist path def = do
  res <- try $ readFile path :: IO (Either IOError String)
  either
    (const $ writeFile path def)
    (const $ return ())
    res
