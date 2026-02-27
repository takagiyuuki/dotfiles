-- lua/plugins/csvview.lua
return {
  "hat0uma/csvview.nvim",
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  opts = {
    parser = { comments = { "#", "//" } },
  },
}

