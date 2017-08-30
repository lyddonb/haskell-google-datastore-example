module Example.Orphans where

import Datastore
import LibPrelude
import Example.Types
import DB.Types (getUUID)
import qualified Data.Aeson as JSON


instance ToValue UUID where
    toValue = toValue . jsonStr . JSON.toJSON
        where jsonStr (JSON.String txt) = txt
              jsonStr n = error $ "UUID JSON should be String but it's: " ++ show n


instance Identifier UUID where
    objectId = Right . encodeHex

instance Identifier Task where
    objectId = objectId . getUUID


instance HasIdentifier Task UUID


instance HasProperties Task where
    encodeProps = (\(JSON.Object o) -> o) . JSON.toJSON
    decodeProps = decodeJsonObject
    excludeKeys _ = ["server_sig"]
