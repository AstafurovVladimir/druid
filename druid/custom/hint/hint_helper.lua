local M = {}

M.hint_is_shown = true
M.current_node_id = "none"
M.hints = {}

function M.hide_hint()
    if table.maxn(M.hints) >= 1 then
        for _, hint in ipairs(M.hints) do
            msg.post(hint[hash("/hint")], "hide")
        end
    end
    M.hint_is_show = false
    M.current_node_id = "none"
end

function M.on_over(self, action_id, action, node, data)
    local node_id = gui.get_id(node)
    if (action_id == hash("touch") and action.repeated or not action_id) then
        if gui.pick_node(node, action.x, action.y) and gui.is_enabled(node, true) then
            if M.current_node_id == gui.get_id(node) then
                return
            end
            local count = data.count
            for i, node in ipairs(data.nodes) do
                table.insert(M.hints, collectionfactory.create("#hint_factory"))
                msg.post(M.hints[i][hash("/hint")], "update", {layer = i, data = node})
            end
            pprint(M.hints)
            msg.post(M.hints[1][hash("/hint")], "show")
            M.hint_is_show = true
            M.current_node_id = gui.get_id(node)
            return
        elseif node_id == M.current_node_id then
            M.hide_hint()
        end
    end
    if M.hint_is_show and action.released then
        M.hide_hint()
    end
end

function M.show_nest(self, level)
    msg.post(M.hints[level][hash("/hint")], "show")
    print(1)
end

function M.final()
    for _, hint in ipairs(M.hints) do
        --msg.post(hint[hash("/hint")], "delete", nil)
        --gui.delete_node(gui.get_node(hint[hash("/hint")]))
    end
    M.hide_hint()
end

return M