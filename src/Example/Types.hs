module Example.Types 
    ( module DB.Types
    , module LibPrelude.Types
    , module Example.Types.Task
    , Handle 
    , ExampleDBException(..)
    )
    where

import DB.Types
import Example.Types.Task
import LibPrelude.Types
import System.IO     (Handle)
import qualified Control.Exception      as Except


data ExampleDBException =
    DBException DBException
    deriving (Eq, Show)

instance HasNotFound ExampleDBException where
    is404 (DBException e) = is404 e
    is404 _ = False

instance Except.Exception ExampleDBException
