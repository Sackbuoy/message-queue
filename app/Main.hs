{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import GHC.Generics as G
import Lib
import Network.Simple.TCP
import Control.Monad (forever)
import Control.Concurrent.Async
import qualified Data.ByteString.Lazy.Char8 as B
import Data.Aeson as J

data Message = Message 
  { context :: String
  , content :: String
} deriving (G.Generic, Show)

instance J.ToJSON Message where
  toEncoding = J.genericToEncoding J.defaultOptions

instance J.FromJSON Message where
  parseJSON = withObject "Message" $ \v -> Message
    <$> v .: "context"
    <*> v .: "content"

main :: IO()
main = do
  thread1 <- async $ listenForMessage "127.0.0.1" "8000"
  wait thread1

listenForMessage :: String -> String -> IO()
listenForMessage host port = listen (Host host) port $ \(listeningSocket, listeningAddr) -> do
  putStrLn $ "Listening on " ++ show listeningAddr
  forever . acceptFork listeningSocket $ \(connectionSocket, remoteAddr) -> do
     putStrLn $ "Connection established from " ++ show remoteAddr
     rawMessage <- recv connectionSocket 64
     case rawMessage of
      Just a -> handleMessage $ decode $ B.fromStrict a
      Nothing -> putStrLn "Failed to receive message"

handleMessage :: Maybe Message -> IO()
handleMessage message = do 
  case message of
    Just a -> putStrLn $ show a
    Nothing -> putStrLn "Failed to parse message as JSON"




-- breakdown:
-- main = do
--  listen (listens for connections, stores results) - messages get sent to this port
--  serve (services data) - messages are pulled from this port

