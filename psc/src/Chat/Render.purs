module Chat.Render
  ( render
  ) where

import Prelude
import Thermite (Render())
import Thermite.Html (text)
import Thermite.Types (Context(), Html())
import qualified Thermite.Events as E
import qualified Thermite.Html.Attributes as HA
import qualified Thermite.Html.Elements as H

import qualified Chat.State as S
import qualified Chat.Action as A

render :: Render _ S.State _ A.Action
render ctx s _ _ = html
  where
    html :: Html _
    html = H.div'
      [ navHeader
      , counter $ s.counter
      , buttons ctx
      ]

counter :: Int -> Html _
counter value = H.p'
  [ text "Value: "
  , text $ show value
  ]

buttons :: Context S.State A.Action -> Html _
buttons ctx = H.p'
  [ H.button (HA.className "btn btn-default" <> E.onClick ctx (\_ -> A.Increment)) [text "Increment"]
  , H.button (HA.className "btn btn-default" <> E.onClick ctx (\_ -> A.Decrement)) [text "Decrement"]
  ]

navHeader :: Html _
navHeader = H.nav (HA.className "navbar navbar-default")
  [ H.div (HA.className "container-fluid")
    [ H.div (HA.className "navbar-header")
      [ H.a (HA.className "navbar-brand" <> HA.href "chat.html") [text "Chat Sample"]
      ]
    ]
  ]
