module Lib.MqttClient
  ( MqttClient()
  , MqttInfo(..)
  , Actions(..)
  , connect
  ) where

import Prelude
import Control.Monad.Eff (Eff())
import qualified Thermite.Action as TA

foreign import data MqttClient :: *

type MqttInfo =
  { host :: String
  , port :: Int
  , clientId :: String
  , username :: String
  , password :: String
  }

type Actions =
  { connected :: forall eff a. MqttClient -> Eff eff a
  , messageArrived :: forall eff a. String -> Eff eff a
  }

foreign import connect :: forall eff. MqttInfo -> String -> Actions -> Eff eff MqttClient
foreign import send :: forall eff. MqttClient -> String -> String -> Eff eff Unit
