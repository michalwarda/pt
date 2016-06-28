-----------------
-- Initial state
-----------------
state = {
  inputText = "",
  items = {
    {text = "Item 1", checked = true},
    {text = "Item 2", checked = false},
  }
};

-----------------
-- Reducer
-----------------
function reduce(state, action)
  local newState = deepcopy(state);
  local actions = {
    updateInput = function() newState.inputText = action.text end,
    updateItemText = function() newState.items[action.index].text = action.text end,
    updateItemChecked = function() newState.items[action.index].checked = action.checked end,
    addItem = function() table.insert(newState.items, ({text = action.text, checked = false})) end,
    removeItem = function() table.remove(newState.items, action.index) end,
  }
  actions[action.type]();

  return newState;
end

-----------------
-- Item Component
-----------------
function Item(item, index)
  function OnCheck(self, _, _)
    dispatch({type = "updateItemChecked", index = index, checked = self:GetChecked()});
  end

  function OnChar(self, _)
    dispatch({type = "updateItemText", index = index, text = self:GetText()});
  end

  function OnDelete(self, _, _)
    dispatch({type = "removeItem", index = index});
  end

  return Div({
    Size = {280, 30},
    Point = {"TOPLEFT", 0, -((index - 1) * 30)},
    Children = {
      CheckBox({
          Size = {30, 30},
          Checked = item.checked,
          Scripts = {PostClick = OnCheck},
          Point = {"LEFT", 0, 0}}),
      Input({
          Size = {180, 30},
          Scripts = {OnChar = OnChar},
          Text = item.text,
          Point = {"LEFT", 40, 0}}),
      Button({
          Size = {30, 30},
          Text = "X",
          Scripts = {PostClick = OnDelete},
          Point = {"LEFT", 225, 0}})
    }
  })
end

-----------------
-- Items list
-----------------
function Items(items)
  local renderedItems = {};
  table.foreach(items, function(index, item)
    local renderedItem = table.insert(renderedItems, Item(item, index));
  end);

  return Div({Size = {280, 280}, Point = {"TOP", 10, -50}, UIParent = "Bg", Children = renderedItems})
end

-----------------
-- Render View
-----------------
function render(state)
  function OnChar(self, _)
    dispatch({type = "updateInput", text = self:GetText()});
  end

  function OnEnterPressed(self)
    dispatch({type = "addItem", text = self:GetText()});
    dispatch({type = "updateInput", text = ""});
  end

  return Div({Root = true, Size = {300, 360}, Point = {"CENTER", 0, 0}, Children = {
    Text({Text = "WoW TodoMVC", UIParent = "TitleBg", Point = {"LEFT", 10, 5}}),
    Input({Size = {250, 30}, Text = state.inputText, Point = {"TOPLEFT", 15, -20}, UIParent = "Bg",
      Scripts = {OnChar = OnChar, OnEnterPressed = OnEnterPressed}}),
    Text({Text = "What needs to be done?", Point = {"TOPLEFT", 10, -10}, UIParent = "Bg"}),
    Items(state.items),
  }}, "BasicFrameTemplateWithInset")
end

-- First Render
renderView();
