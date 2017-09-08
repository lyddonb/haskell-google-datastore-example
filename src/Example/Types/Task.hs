{-# LANGUAGE DeriveGeneric, DeriveAnyClass, RecordWildCards #-}
module Example.Types.Task
    ( Task(..)
    )
    where

import GHC.Generics
import DB.Types (UUID, HasUUID(..))
import Data.Aeson (FromJSON, ToJSON)
import qualified Data.Serialize as Bin


data Task = Task
    { task_id :: UUID
    , content :: String
    } deriving (Show, Generic, ToJSON, FromJSON, Bin.Serialize)


instance HasUUID Task where
    serializeForID Task{..} = Bin.encode content
