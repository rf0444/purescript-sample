module Chat.State
  ( State(..)
  , initialState
  ) where

type State = { counter :: Int }

initialState :: State
initialState = { counter: 0 }
