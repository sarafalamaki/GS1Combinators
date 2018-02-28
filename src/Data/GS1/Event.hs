{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeOperators         #-}
{-# LANGUAGE OverloadedStrings     #-}

-- | module for events
-- events can be an ObjectEvent (when the object is created),
--   an aggegation (collection of multiple events),
--   a transaction (some transaction has been made between 2 parties),
--   or a transformation (some product has been converted into another)
-- contains Event-related types helper functions,
--   and functions for converting a DWhat to a string representation of the relevant event

module Data.GS1.Event where

import            GHC.Generics
import            Data.GS1.DWhat
import            Data.GS1.DWhen
import            Data.GS1.DWhere
import            Data.GS1.DWhy
import            Data.GS1.EventID
import            Data.GS1.Utils
import            Data.Aeson
import qualified  Data.Text as T
import            Data.String (IsString)
import            Data.Aeson.TH
import            Data.Swagger

data EventType = ObjectEventT
               | AggregationEventT
               | TransactionEventT
               | TransformationEventT
               deriving (Show, Eq, Generic, Enum, Read)

$(deriveJSON defaultOptions ''EventType)
instance ToSchema EventType

evTypeToTextLike :: IsString a => EventType -> a
evTypeToTextLike ObjectEventT         = "ObjectEvent"
evTypeToTextLike AggregationEventT    = "AggregationEvent"
evTypeToTextLike TransactionEventT    = "TransactionEvent"
evTypeToTextLike TransformationEventT = "TransformationEvent"

-- | Calls the appropriate evTypeToTextLike for a DWhat
dwhatToEventTextLike :: IsString a => DWhat -> a
dwhatToEventTextLike (ObjectDWhat _ _ ) = evTypeToTextLike ObjectEventT
dwhatToEventTextLike (AggregationDWhat _ _ _ ) = evTypeToTextLike AggregationEventT
dwhatToEventTextLike (TransactionDWhat _ _ _ _) = evTypeToTextLike TransactionEventT
dwhatToEventTextLike (TransformationDWhat _ _ _) = evTypeToTextLike TransformationEventT


mkEventType :: T.Text -> Maybe EventType
mkEventType = mkByName

allEventTypes :: [EventType]
allEventTypes = [(ObjectEventT)..] -- bug in hlint! brackets are not redundant

data Event = Event
  {
    _type  :: EventType
  , _eid   :: Maybe EventID -- foreign event id, comes from the XML
  , _what  :: DWhat
  , _when  :: DWhen
  , _why   :: DWhy
  , _where :: DWhere
  }
  deriving (Show, Eq, Generic)
$(deriveJSON defaultOptions ''Event)
instance ToSchema Event
