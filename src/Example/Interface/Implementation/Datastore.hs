module Example.Interface.Implementation.Datastore
    ( module Example.Interface.Implementation.Datastore
    , module Example.Interface.Spec
    )
   where

import LibPrelude
import Example.Interface.Spec
import Example.Types
import Example.Creation (insertTask)
import DB.Env as Env


projectId :: ProjectId
{-projectId = "datastore-test"-}
projectId = "rk-playground"

taskNS :: NamespaceId
taskNS = "task3"

toNamespace :: DBConsumer -> NamespaceId
toNamespace TaskDB = taskNS

instance DBHandle DatastoreConf where
    getHandle h logLvl = do
        env <- defaultAppDatastoreEnv h logLvl
        return $ DatastoreConf env projectId logLvl h


instance ExampleDB Datastore DatastoreConf where
    runDB c d = fmapL DBException <$> runDatastore c d
    create = create'


create' :: Task -> Datastore ()
create' rpc = do
    _ <- insertTask (toNamespace TaskDB) rpc
    return ()
