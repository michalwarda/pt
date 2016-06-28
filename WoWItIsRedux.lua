states = {};
currentStateIndex = 1;
states[currentStateIndex] = {
  state = {
    inputText = "",
    items = {{text = "Item 1", checked = true}, {text = "Item 2", checked = false}},
    hidden = false,
    filterChecked = false
  }, action = {type = "INIT"}
};

timeTraveling = false;
tt = true;

function getState()
  return state;
end

function setState(newState, action)
  timeTraveling = false;
  state = newState;
  local diff = {state = state, action = action};

  currentStateIndex = currentStateIndex + 1;
  lastIndex = currentStateIndex;
  states[currentStateIndex] = diff;

  renderView(newState);
end

function dispatch(action)
  setState(reduce(getState(), action), action);
end

function goBack()
  timeTraveling = true;
  currentStateIndex = currentStateIndex - 1;

  state = states[currentStateIndex].state;
  renderView(state);
end

function goForward()
  currentStateIndex = currentStateIndex + 1;
  local diff = states[currentStateIndex];

  state = diff.state;
  renderView(state);
end

function pastEnabled()
  return currentStateIndex > 1;
end

function futureEnabled()
  return timeTraveling and currentStateIndex < lastIndex;
end

function TimeTravel()
  return Div({Size = {300, 100}, Point = {"RIGHT", 600, 0}, Hidden = tt, Children = {
    Text({Text = "TimeTravel", UIParent = "TitleBg", Point = {"LEFT", 10, 5}}),
    Text({Text = "Where do you want to go?", Point = {"TOPLEFT", 10, -10}, UIParent = "Bg"}),
    Button({Size = {120, 30}, Text = "Back to Past!", Point = {"LEFT", 10, -15}, Enabled = pastEnabled(),
      Scripts = {PostClick = goBack}}),
    Button({Size = {120, 30}, Text = "Back to Future!", Point = {"LEFT", 140, -15}, Enabled = futureEnabled(),
      Scripts = {PostClick = goForward}})
  }}, "BasicFrameTemplateWithInset")
end

SLASH_TT1 = '/tt';
local function ttHandler(msg, editbox)
  tt = not tt;
  renderView(getState());
end

SlashCmdList["TT"] = ttHandler;
