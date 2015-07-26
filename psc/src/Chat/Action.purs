module Chat.Action
  ( Action(..)
  , Task(..)
  , MqttInfo(..)
  ) where

import qualified Chat.State as S

type MqttInfo =
  { host :: String
  , port :: Int
  , clientId :: String
  , username :: String
  , password :: String
  }

data Action
  = ConnectionFormInput (S.ConnectionForm -> S.ConnectionForm)
  | Connect
  | MqttInfoResponse MqttInfo
  | ResponseError
  | Connected
  | PostArrived S.Post
  | PostFormInput (S.PostForm -> S.PostForm)
  | Post Int

data Task
  = RequestMqtt
  | MqttConnect MqttInfo
  | MqttSend S.Post
