module Main where

import Lib
import Network.Simple.TCP

main :: IO ()
main = serve (Host "127.0.0.1") "8000" $ \(connectionSocket, remoteAddr) -> do
  putStrLn $ "TCP connection established from " ++ show remoteAddr
  -- print $ (recv connectionSocket 64) ::
-- import Network.Socket
-- import qualified Network.Socket.ByteString as B
-- import Data.ByteString.Char8(pack,unpack)
--
-- main::IO()
-- main=do
--     sock<-socket AF_INET Stream 0
--     bind sock (SockAddrInet 8500 0x0100007f)
--     listen sock 3
--     (csock,_)<-accept sock
--     handle csock
--
-- handle::Socket->IO()
-- handle csock=do
--     dat<-B.recv csock 2000
--     -- sent<-B.send  csock $ pack "Hi!!"
--     print $ unwords  ["Received :",unpack dat]
--     handle csock
