previousStates = {};

function getState()
  return state;
end

function setState(newState, action)
  local diff = {state = state, action = action};
  table.insert(previousStates, diff);

  state = newState;
  renderView(newState);
end

function dispatch(action)
  setState(reduce(getState(), action), action);
end
