{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass, GADTs, FlexibleContexts, DataKinds, RecordWildCards #-}
import qualified Example as DB 
import Example (DatastoreConf(..))
import Control.Lens
import Control.Monad
import System.IO ( stderr, stdout ) 

main :: IO ()
main = do
    -- Env/conf
    dbConf <- DB.getHandle stderr DB.LevelInfo
    res <- datastoreTest $ updateConf dbConf
    putStrLn $ "\n\nDone! Executed " ++ show res

runDbRethrow  :: forall c m h. DB.ExampleDB m h => h -> m c -> IO c
runDbRethrow cfg = DB.throwLeft <=< DB.runDB cfg

datastoreTest :: DatastoreConf -> IO Int
datastoreTest cfg = do
    let sampleTask = DB.Task DB.zeroUUID "foo" 
    res <- runDbRethrow cfg (DB.create sampleTask :: DB.Datastore ())
    return 0

updateConf :: DatastoreConf -> DatastoreConf
updateConf c@(DatastoreConf { dcAuthEnv = ae }) = c { dcAuthEnv = localConf ae }

localConf :: DB.HasEnv s a => a -> a
localConf = DB.override (DB.datastoreService & DB.serviceHost .~ "localhost"
                                             & DB.servicePort .~ 8080
                                             & DB.serviceSecure .~ False
                                             & DB.serviceTimeout .~ (Just 5))
