{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass, GADTs, FlexibleContexts, DataKinds, ScopedTypeVariables#-}
module Example.Creation where

import Example.Orphans ()
import Example.Types
import DB.Types
import DB.Tx.Safe
import DB.Error.Util
import DB.Model.Convert

import Debug.Trace


insertTask :: HasScope '[AuthDatastore] ProjectsBeginTransaction =>
              NamespaceId
           -> Task
           -> Datastore (Tagged Task CommitResponse)
insertTask nsId tsk =
    mkMutation nsId
        (Insert $ EntityWithAnc tsk root) >>=
            runReqWithTx . Tagged


{-removeTask :: HasScope '[AuthDatastore] ProjectsBeginTransaction =>-}
              {-NamespaceId-}
           {--> Key-}
           {--> Datastore (Tagged Task CommitResponse)-}
{-removeTask nsId key = do-}
    {-let fullKey = root <//> key :: RootKey Task-}
    {-partId <- mkPartitionId nsId-}
    {-runReqWithTx $ mkDelete-}
        {-(Just partId)-}
        {-fullKey-}


runReqWithTx :: HasScope '[AuthDatastore] ProjectsBeginTransaction =>
    Tagged a CommitRequest -> Datastore (Tagged a CommitResponse)
runReqWithTx commitReq =
    withTx ( const $ return ((), unTagged commitReq) ) >>=
        \(_,responseM) -> maybe
           (internalErrorM "runReqWithTx: 'withTx' did not return CommitResponse")
           return
           (Tagged <$> responseM)
