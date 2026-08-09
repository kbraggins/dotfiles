-- Generate out-of-class definitions from declarations in a .h,
-- the way Visual Studio / JetBrains do it.
return {
  "Badhi/nvim-treesitter-cpp-tools",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "c", "cpp", "objc", "objcpp", "cuda" },
  config = function()
    require("nt-cpp-tools").setup({
      preview = {
        quit = "q", -- reject the generated snippet
        accept = "<tab>", -- insert it
      },
      header_extension = "h",
      source_extension = "cpp",
      -- The stock TSCppDefineClassFunc previews and inserts into the *current*
      -- buffer. This variant skips the preview and writes straight into the
      -- matching .cpp, which is the Visual Studio / JetBrains behaviour.
      custom_define_class_function_commands = {
        TSCppImplWrite = {
          output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
        },
      },
    })

    -- :CppImplMissing -- whole-header, no visual selection, and only emits
    -- definitions that don't already exist in the .cpp, so it is safe to rerun.
    -- (TSCppImplWrite regenerates everything in range and will duplicate.)
    local function signature_key(block)
      -- Collapse a generated definition down to `Class::name(args)[const]` with
      -- all whitespace removed, so it can be matched against the .cpp text.
      local decl = block:match("^(.-)%s*%b{}$") or block
      decl = decl:gsub("template%s*<[^\n]*>", "") -- drop the template<> line
      local key = decl:match("[%w_~]+%s*::%s*[~%w_]+%s*%b()")
      if not key then
        return nil -- unparsed (e.g. operators); caller re-emits to be safe
      end
      if decl:match("%b()%s*const") then
        key = key .. "const"
      end
      return (key:gsub("%s+", ""))
    end

    -- The generated definitions are unqualified (`Widget::foo`, never
    -- `app::ui::Widget::foo`), so for a class inside a namespace they are only
    -- valid *inside* that same namespace block in the .cpp. These helpers find
    -- it, or build it when the source file doesn't have one yet.
    local ts = vim.treesitter

    local function root_of(buf)
      local ok, parser = pcall(ts.get_parser, buf, "cpp")
      if not ok or not parser then
        return nil
      end
      return parser:parse()[1]:root()
    end

    local function ns_name_parts(node, buf) -- handles `namespace a::b {`
      local parts = {}
      local name = node:field("name")[1]
      if name then -- anonymous namespaces contribute nothing
        for p in ts.get_node_text(name, buf):gmatch("[%w_]+") do
          parts[#parts + 1] = p
        end
      end
      return parts
    end

    local function find_first(node, types)
      for child in node:iter_children() do
        if types[child:type()] then
          return child
        end
        local found = find_first(child, types)
        if found then
          return found
        end
      end
    end

    -- Namespaces enclosing the first class/struct declared in the header.
    local function header_ns_path(buf)
      local root = root_of(buf)
      local class = root and find_first(root, { class_specifier = true, struct_specifier = true })
      local path = {}
      local node = class and class:parent()
      while node do
        if node:type() == "namespace_definition" then
          local parts = ns_name_parts(node, buf)
          for i = #parts, 1, -1 do
            table.insert(path, 1, parts[i])
          end
        end
        node = node:parent()
      end
      return path
    end

    -- Deepest namespace_definition in `buf` whose full path equals `target`.
    local function find_ns(node, buf, target, acc)
      local match
      for child in node:iter_children() do
        local next_acc = acc
        if child:type() == "namespace_definition" then
          next_acc = vim.list_extend(vim.deepcopy(acc), ns_name_parts(child, buf))
          if vim.deep_equal(next_acc, target) then
            match = child
          end
        end
        match = find_ns(child, buf, target, next_acc) or match
      end
      return match
    end

    vim.api.nvim_create_user_command("CppImplMissing", function()
      local src = vim.fn.expand("%:p:r") .. ".cpp"
      if vim.fn.filereadable(src) == 0 then
        vim.notify("No matching source file: " .. src, vim.log.levels.ERROR)
        return
      end

      local header = vim.api.nvim_get_current_buf()
      local ns_path = header_ns_path(header)

      local src_buf = vim.fn.bufadd(src)
      vim.fn.bufload(src_buf)
      local existing =
        table.concat(vim.api.nvim_buf_get_lines(src_buf, 0, -1, false), "\n"):gsub("%s+", "")

      require("nt-cpp-tools.internal").imp_func(1, vim.api.nvim_buf_line_count(header), function(output)
        local missing = {}
        for block in output:gmatch("%s*(.-%b{})") do
          local key = signature_key(block)
          if not key or not existing:find(key, 1, true) then
            table.insert(missing, block)
          end
        end

        if #missing == 0 then
          vim.notify("All declarations are already implemented in " .. vim.fn.fnamemodify(src, ":t"))
          return
        end

        local body = vim.split(table.concat(missing, "\n\n"), "\n")
        local at, ns_note = -1, ""

        if #ns_path > 0 then
          local root = root_of(src_buf)
          local ns = root and find_ns(root, src_buf, ns_path, {})
          if ns then
            local _, _, close_row = ns:range()
            at = close_row -- insert just above the namespace's closing brace
            ns_note = " inside namespace " .. table.concat(ns_path, "::")
          else
            -- No such namespace in the .cpp yet: wrap the definitions in one.
            local open, close = {}, {}
            for _, part in ipairs(ns_path) do
              table.insert(open, "namespace " .. part .. " {")
              table.insert(close, 1, "} // namespace " .. part)
            end
            body = vim.list_extend(open, body)
            vim.list_extend(body, close)
            ns_note = " in a new namespace " .. table.concat(ns_path, "::") .. " block"
          end
        end

        -- Keep one blank line on each side of the inserted block.
        local above = at == -1 and vim.api.nvim_buf_line_count(src_buf) - 1 or at - 1
        if above >= 0 and vim.api.nvim_buf_get_lines(src_buf, above, above + 1, false)[1] ~= "" then
          table.insert(body, 1, "")
        end
        if at ~= -1 then
          table.insert(body, "")
        end

        vim.api.nvim_buf_set_lines(src_buf, at, at, false, body)
        vim.cmd("vsplit " .. vim.fn.fnameescape(src))
        vim.notify(
          ("Added %d definition%s%s"):format(#missing, #missing == 1 and "" or "s", ns_note)
        )
      end)
    end, { desc = "Implement declarations missing from the .cpp" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("cpp_tools_keymaps", { clear = true }),
      pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
      callback = function(ev)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end

        map("n", "<leader>cai", "<cmd>CppImplMissing<cr>", "Implement Missing Declarations -> .cpp")
        map({ "n", "v" }, "<leader>ci", "<cmd>TSCppImplWrite<cr>", "Implement Declarations -> .cpp")
        map({ "n", "v" }, "<leader>cI", "<cmd>TSCppDefineClassFunc<cr>", "Implement Declarations (preview, inline)")
        map({ "n", "v" }, "<leader>ce", "<cmd>TSCppMakeConcreteClass<cr>", "Implement Pure Virtuals")
        map("n", "<leader>c3", "<cmd>TSCppRuleOf3<cr>", "Rule of 3")
        map("n", "<leader>c5", "<cmd>TSCppRuleOf5<cr>", "Rule of 5")
      end,
    })
  end,
}
