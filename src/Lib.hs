{-# LANGUAGE GeneralizedNewtypeDeriving, DataKinds, FlexibleContexts, FlexibleInstances, MultiParamTypeClasses #-}
module Lib
    ( someFunc
    ) where

import Control.Lens hiding (op)
import Control.Monad.Trans.Resource             as Res
import Control.Monad.Trans.Resource (liftResourceT, runResourceT)
import Control.Monad.IO.Class                   (MonadIO)
import Data.Int                         (Int64)
import Data.Tagged (Tagged(..))
import System.IO (Handle, stdout)

import qualified Control.Monad.Base             as Base
import qualified Control.Monad.Catch            as Catch
import qualified Control.Monad.Logger           as Log
import qualified Control.Monad.Reader           as R
import qualified Control.Monad.Writer.Strict    as W
import qualified Data.ByteString as BS
import qualified Data.Text as T
import qualified Network.HTTP.Conduit   as HTTPS
import qualified Network.Google         as Google
import Network.Google (HasScope, runGoogle)
import Network.Google.Datastore 
import Network.Google.Resource.Datastore.Projects.BeginTransaction (ProjectsBeginTransaction)

type AuthDatastore = "https://www.googleapis.com/auth/datastore"

someFunc :: IO ()
someFunc = do
    env <- defaultDatastoreEnv

    {-runResourceT . Google.runGoogle env $ do-}
        {-Google.send _-}

    putStrLn "someFunc1"

defaultDatastoreEnv :: IO (Google.Env '[AuthDatastore])
defaultDatastoreEnv = do
    -- Setup a logger to emit 'Debug' (or higher) log statements to 'stdout':
    logger  <- Google.newLogger Google.Debug stdout

    manager <- HTTPS.newManager HTTPS.tlsManagerSettings

    Google.newEnv <&> (Google.envLogger .~ logger) .
                      (Google.envScopes .~ datastoreScope) .  
                      (Google.envManager .~ manager)
