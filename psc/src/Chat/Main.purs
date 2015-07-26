module Chat.Main
  ( main
  ) where

import Prelude
import Control.Monad.Eff (Eff())
import DOM (DOM())
import qualified Thermite as T
import qualified Thermite.Action as TA

import qualified Chat.Action as A
import qualified Chat.Render as R
import qualified Chat.State as S
import qualified Chat.Update as U

main :: forall eff. Eff (dom :: DOM | eff) Unit
main = T.render (T.createClass spec) {}

spec :: T.Spec _ S.State _ A.Action
spec = T.componentWillMount A.Increment $ T.simpleSpec S.initialState perform R.render

perform :: T.PerformAction _ S.State _ A.Action
perform _ action = do
    TA.modifyState (U.update action)
