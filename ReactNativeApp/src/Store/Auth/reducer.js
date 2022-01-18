import {LOGIN,LOGOUT} from './types'

const initialState = null;

const userReducer = (state = initialState, action) => {
  switch (action.type) {
    case LOGIN:
      return action.payload;
    case LOGOUT:
        return initialState;
    default:
      return state
  }
}

export default userReducer
