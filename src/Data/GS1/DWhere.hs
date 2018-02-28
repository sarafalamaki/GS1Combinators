{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell       #-}

-- | module for the Where dimension
-- contains a DWhere type and relevant type aliases

module Data.GS1.DWhere where

import           GHC.Generics

import           Data.GS1.EPC
import           Data.Aeson
import           Data.Aeson.TH
import           Data.Swagger

import           Data.Aeson.Text
import qualified Data.Text.Lazy as TxtL

-- |Location synonym
type ReadPointLocation = LocationEPC

-- |Location synonym
type BizLocation = LocationEPC

type SrcDestLocation = (SourceDestType, LocationEPC)

data DWhere = DWhere
  {
    _readPoint   :: [ReadPointLocation]
  , _bizLocation :: [BizLocation]
  , _srcType     :: [SrcDestLocation]
  , _destType    :: [SrcDestLocation]
  }
  deriving (Show, Eq, Generic)
$(deriveJSON defaultOptions ''DWhere)
instance ToSchema DWhere
