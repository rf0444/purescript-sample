module Chat.Action
  ( Action(..)
  , Task(..)
  , MqttInfo(..)
  ) where

import qualified Chat.State as S

import qualified Lib.MqttClient as MC

type MqttInfo = MC.MqttInfo

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
