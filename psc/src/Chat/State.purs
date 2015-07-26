module Chat.State
  ( State(..)
  , NotConnectedState(..)
  , ConnectingState(..)
  , ConnectedState(..)
  , Post(..)
  , ConnectionForm(..)
  , PostForm(..)
  , initialState
  ) where

data State
  = NotConnected NotConnectedState
  | Connecting ConnectingState
  | Connected ConnectedState

type NotConnectedState =
  { form :: ConnectionForm
  }

type ConnectionForm =
  { name :: String
  }

type ConnectingState =
  { name :: String
  }

type ConnectedState =
  { name :: String
  , form :: PostForm
  , posts :: Array Post
  }

type PostForm =
  { content :: String
  }

type Post =
  { user :: String
  , time :: Int
  , content :: String
  }

initialState :: State
initialState = NotConnected
  { form:
    { name: ""
    }
  }
