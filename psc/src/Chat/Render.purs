module Chat.Render
  ( render
  ) where

import Prelude
import Thermite (Render())
import Thermite.Html (text)
import Thermite.Types (Context(), Html())
import qualified Thermite.Events as E
import qualified Thermite.Html.Attributes as HA
import qualified Thermite.Html.Attributes.Unsafe as HAU
import qualified Thermite.Html.Elements as H

import qualified Chat.State as S
import qualified Chat.Action as A

render :: Render _ S.State _ A.Action
render ctx s _ _ = html
  where
    html :: Html _
    html = H.div'
      [ navHeader
      , content ctx s
      ]

navHeader :: Html _
navHeader = H.nav (HA.className "navbar navbar-default")
  [ H.div (HA.className "container-fluid")
    [ H.div (HA.className "navbar-header")
      [ H.a (HA.className "navbar-brand" <> HA.href "chat.html") [ text "Chat Sample" ]
      ]
    ]
  ]

content :: Context S.State A.Action -> S.State -> Html _
content ctx = H.div (HA.className "container") <<< children
  where
    children :: S.State -> Array (Html _)
    children (S.NotConnected s) =
      [ H.div (HA.className "row") [ userInput ctx ]
      ]
    children (S.Connecting _) =
      [ H.div (HA.className "row") [ text "connecting..." ]
      ]
    children (S.Connected s) =
      [ H.div
        (HA.className "row" <> HAU.style { padding: "0 20px 10px 0" })
        [ showUser s.name ]
      , H.div
        (HA.className "row" <> HAU.style { padding: "10px" })
        [ postForm ctx s ]
      , H.div
        (HA.className "row" <> HAU.style { padding: "10px" })
        [ posts s.posts ]
      ]

userInput :: Context S.State A.Action -> Html _
userInput ctx =
  H.div (HAU.style { display: "flex" })
    [ H.div (HAU.style { flex: 1, padding: "0 5px" }) 
      [ H.input
        (HA.className "form-control" <> HA.placeholder "Name" <> E.onInput ctx nameInput) []
      ]
    , H.div (HAU.style { width: "100px", padding: "0 10px", textAlign: "center" })
      [ H.button
        (HA.className "btn btn-success" <> HAU.style { display: "block", width: "100%" } <> E.onClick ctx (\_ -> A.Connect))
        [ text "Connect" ]
      ]
    ]
  where
    nameInput event = A.ConnectionFormInput
      (\form -> form
        { name = eventTargetValue event
        }
      )

showUser :: String -> Html _
showUser name = H.div (HAU.style { textAlign: "right" }) [ text ("user: " ++ name) ]

postForm :: Context S.State A.Action -> S.ConnectedState -> Html _
postForm ctx s =
  H.div (HAU.style { display: "flex" })
    [ H.div (HAU.style { flex: 1, padding: "0 5px" })
      [ H.input (HA.className "form-control" <> HA.placeholder "Content" <> E.onInput ctx postInput) []
      ]
    , H.div (HAU.style { width: "100px", padding: "0 10px", textAlign: "center" })
      [ H.button
        (HA.className "btn btn-success" <> HAU.style { display: "block", width: "100%" } <> E.onClick ctx postClick)
        [ text "Post" ]
      ]
    ]
  where
    postInput event = A.PostFormInput
      (\form -> form
        { content = eventTargetValue event
        }
      )
    postClick = A.Post <<< eventTimestamp

posts :: Array S.Post -> Html _
posts xs =
  H.table (HA.className "table")
    [ H.thead'
      [ H.th (HAU.style { width: "200px" }) [ text "user" ]
      , H.th (HAU.style { width: "auto"  }) [ text "content" ]
      , H.th (HAU.style { width: "200px" }) [ text "timestamp" ]
      ]
    , H.tbody' $ map toTr xs
    ]
  where
    toTr post = H.tr'
      [ H.td' [ text (post.user) ]
      , H.td' [ text (post.content) ]
      , H.td' [ text (show post.time) ]
      ]

foreign import eventTargetValue :: forall event. event -> String
foreign import eventTimestamp :: forall event. event -> Int
