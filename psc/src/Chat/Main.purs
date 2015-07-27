module Chat.Main
  ( main
  ) where

import Prelude
import Control.Monad.Eff (Eff())
import DOM (DOM())

import qualified React as R
import qualified React.DOM as D
import qualified React.DOM.Props as P

type State = Int

initialState :: State
initialState = 0

main :: forall eff. Eff (dom :: DOM | eff) R.UI
main = do
  let component = D.div [] [ counter {} ]
  R.renderToBody component

incrementCounter :: forall eff props. R.UIRef -> R.Event -> R.EventHandlerContext eff props State State
incrementCounter ctx e = do
  val <- R.readState ctx
  R.writeState ctx (val + 1)

counter :: forall props. props -> R.UI
counter = R.mkUI $ R.spec initialState \ctx -> do
  val <- R.readState ctx
  return $ D.p
    [ P.className "Counter"
    , P.onClick (incrementCounter ctx)
    ] 
    [ D.text (show val)
    , D.text " Click me to increment!"
    ]
