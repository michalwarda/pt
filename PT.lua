-----------------
-- Initial state
-----------------
state = {
  inputText = "",
  items = {},
  hidden = false,
  filterChecked = false,
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
    toggleHidden = function() newState.hidden = not newState.hidden end,
    toggleFilter = function() newState.filterChecked = not newState.filterChecked end,
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
      CheckBox({Size = {30, 30}, Checked = item.checked, Scripts = {PostClick = OnCheck}, Point = {"LEFT", 0, 0}}),
      Input({Size = {180, 30}, Scripts = {OnChar = OnChar}, Text = item.text, Point = {"LEFT", 40, 0}}),
      Button({Size = {30, 30}, Text = "X", Scripts = {PostClick = OnDelete}, Point = {"LEFT", 225, 0}})
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

  function displayedItems()
    if state.filterChecked then
      return table.filter(state.items, function(item) return item.checked end)
    else
      return state.items;
    end
  end

  function toggleFilter()
    dispatch({type = "toggleFilter"});
  end

  return {
    Div({Size = {300, 360}, Point = {"CENTER", 0, 0}, Hidden = state.hidden, Children = {
      Text({Text = "WoW TodoMVC", UIParent = "TitleBg", Point = {"LEFT", 10, 5}}),
      Input({Size = {250, 30}, Text = state.inputText, Point = {"TOPLEFT", 15, -20}, UIParent = "Bg",
        Scripts = {OnChar = OnChar, OnEnterPressed = OnEnterPressed}}),
      Text({Text = "What needs to be done?", Point = {"TOPLEFT", 10, -10}, UIParent = "Bg"}),
      Items(displayedItems()),
      CheckBox({Size = {30, 30}, Checked = state.filterChecked, Scripts = {PostClick = toggleFilter}, Point = {"BOTTOMLEFT", 10, 10}}),
      Text({Text = "Filter Checked Items", Point = {"BOTTOMLEFT", 50, 30}}),
    }}, "BasicFrameTemplateWithInset"),
    TimeTravel(),
  }
end

-----------------
-- First Render
-----------------
renderView();

-----------------
-- Slash CMD
-----------------
SLASH_TODO1 = '/todo';
local function handler(msg, editbox)
  dispatch({type = "toggleHidden"});
end

SlashCmdList["TODO"] = handler;

dispatch({type = "addItem", text = "Find Inspiration"})
dispatch({type = "addItem", text = "Get Fame!"})
dispatch({type = "updateItemChecked", index = 1, checked = true})
dispatch({type = "addItem", text = "Do something interesting in React"})
dispatch({type = "addItem", text = "Run React In WoW (in Lua)"})
dispatch({type = "updateItemText", index = 4, text = "Create React in WoW (in Lua)"})
dispatch({type = "addItem", text = "Create a TodoMVC in WoW it is React!"})
dispatch({type = "updateItemChecked", index = 3, checked = true})
dispatch({type = "updateItemChecked", index = 4, checked = true})
dispatch({type = "addItem", text = "Do weird stuff!"})
dispatch({type = "addItem", text = "Thank you very much!"})
goBack()
goBack()
