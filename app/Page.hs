{-# LANGUAGE OverloadedStrings #-}
module Page (app) where

import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html ((!))
import Data.String

app items =
  H.html $ do
    H.head $ do
      H.title "todo list"
      H.link
        ! A.rel "stylesheet"
        ! A.href "styles.css"
      H.script
        ! A.src "script.js"
        ! A.defer ""
        $ ""
    H.body $ do
      template "item-template" $ item ""
      root items

root items =
  H.div
    ! A.id "root"
    $ H.div
      ! A.id "container"
      $ do
        input
          ! A.id "todo-add-input"
          ! A.placeholder "Type what you need to do, then press Enter"
        list items

list items =
  H.ul
    ! A.id "list"
    $ mapM_ item items

item x =
  H.li
    ! A.class_ "item"
    $ do
      input
        ! A.value (fromString x)
        ! A.readonly ""
      H.button
        ! A.class_ "item-delete-btn"
        $ ""

input =
  H.input
    ! A.class_ "input"
    ! A.spellcheck ""

template name =
  H.div
    ! A.id name
    ! A.class_ "template"
