module Routes (routes) where

import Happstack.Server
import Control.Monad.IO.Class
import Data.Aeson
import Data.Foldable
import Page

type Items = [String]
type RequestHandler = IO Items -> (Items -> IO ()) -> RequestHandlerResult
type RequestHandlerResult = ServerPartT IO Response

-- | Imperative version of `Data.Maybe.maybe`.
imprMaybe m noth just = maybe noth just m

routes :: IO Items -> (Items -> IO ()) -> ServerPartT IO Response
routes readItems writeItems =
  msum [
    itemsDir $ do
      method GET
      nullDir
      getItems readItems writeItems
      ,
    itemsDir $ do
      method POST
      nullDir
      setItems readItems writeItems
      ,
    do
      method GET
      nullDir
      receiveApp readItems writeItems
      ,
    serveDirectory DisableBrowsing ["styles.css"] "public",
    notFound $ toResponse "Not found"
  ]
  where
    itemsDir = dir "items"

getItems :: RequestHandler
getItems readItems _ = do
  encodedItems <- liftIO $ encode <$> readItems
  ok $ toResponse encodedItems

setItems :: RequestHandler
setItems _ writeItems = do
  req <- askRq
  maybeBody <- takeRequestBody req
  imprMaybe (maybeBody >>= decode . unBody)
    (badRequest $ toResponse ())
    $ \items -> do
      liftIO $ writeItems items
      ok $ toResponse ()

receiveApp :: RequestHandler
receiveApp readItems _ = do
  items <- liftIO readItems
  ok $ toResponse $ app items
