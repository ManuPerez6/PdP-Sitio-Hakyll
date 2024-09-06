module Main (main) where
import Hakyll

main :: IO ()
main = hakyll $ do
    match (fromGlob "images/*") $ do
        route idRoute
        compile copyFileCompiler

    match (fromList [fromFilePath "about.rst", fromFilePath "contact.markdown"]) $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate (fromFilePath "templates/default.html") defaultContext
            >>= relativizeUrls

    match (fromGlob "index.html") $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll (fromGlob "posts/*")
            let indexContext =
                    listField "posts" postCtx (return posts) <>
                    constField "title" "Home" <>
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexContext
                >>= loadAndApplyTemplate (fromFilePath "templates/default.html") indexContext
                >>= relativizeUrls

    match (fromGlob "templates/*") $ compile templateBodyCompiler

postCtx :: Context String
postCtx = dateField "date" "%B %e, %Y" <> defaultContext
