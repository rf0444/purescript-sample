module Chat.Update
  ( update
  ) where

import Prelude

import qualified Chat.Action as A
import qualified Chat.State as S

update :: A.Action -> S.State -> S.State
update A.Increment o = { counter: o.counter + 1 }
update A.Decrement o = { counter: o.counter - 1 }
