{-# LANGUAGE FunctionalDependencies #-}
module Example.Interface.Spec 
    ( --module Example.Inteface.Spec
    module Example.Types
    , DBHandle(..)
    , ExampleDB(..)
    , DBConsumer(..)
    )
    where

import Example.Types

-- | Run database operations using this handle.
--   Acquired at application startup.
class DBHandle h where 
    getHandle :: Handle -> LogLevel -> IO h

class (DBHandle h, MonadIO m) => ExampleDB m h | m -> h where
    -- | Run database operations
    runDB :: h -> m a -> IO (Either ExampleDBException a)
    -- | Create new task
    -- TODO: Make generic
    create :: Task -> m ()


data DBConsumer =
    TaskDB
