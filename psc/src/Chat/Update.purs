module Chat.Update
  ( UpdateResult(..)
  , update
  ) where

import Prelude

import qualified Chat.Action as A
import qualified Chat.State as S

type UpdateResult m t =
  { next :: m
  , tasks :: Array t
  }

update :: A.Action -> S.State -> UpdateResult S.State A.Task
update (A.ConnectionFormInput f) (S.NotConnected s) = result next []
  where
    next = S.NotConnected s { form = f (s.form) }
update A.Connect c@(S.NotConnected s) = result (next s.form.name) []
  where
    next "" = c
    next name = S.Connecting { name: name }
update A.ResponseError (S.Connecting _) = result next []
  where
    next = S.NotConnected
      { form:
        { name: ""
        }
      }
update (A.MqttInfoResponse info) c@(S.Connecting _) = result next []
  where
    next = c
update A.Connected (S.Connecting s) = result next []
  where
    next = S.Connected
      { name: s.name
      , form: { content: "" }
      , posts: []
      }
update (A.PostFormInput f) (S.Connected s) = result next []
  where
    next = S.Connected s { form = f (s.form) }
update (A.Post t) (S.Connected s) = result next []
  where
    next = S.Connected s { form = { content: "" } }
update (A.PostArrived p) (S.Connected s) = result next []
  where
    next = S.Connected s { posts = [p] ++ s.posts }
update _ s = result s []

result :: S.State -> Array A.Task -> UpdateResult S.State A.Task
result next tasks = { next: next, tasks: tasks }
