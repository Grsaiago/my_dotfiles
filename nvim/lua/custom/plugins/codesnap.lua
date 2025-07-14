local savePrintsTo = '~/codeSnapshots'
return {
  { -- Take a screenshot / printscreen of code
    'mistricky/codesnap.nvim',
    build = 'make',
    keys = {
      {
        '<leader>pc',
        ':CodeSnap<cr>',
        mode = 'x',
        desc = '[P]rint to [C]lippboard',
      },
      {
        '<leader>phc',
        ':CodeSnapHighlight<cr>',
        mode = 'x',
        desc = '[P]rint with [H]ighlight to [C]lippboard',
      },
      {
        '<leader>ps',
        ':CodeSnapSave<cr>',
        mode = 'x',
        desc = '[P]rint and [S]ave',
      },
      {
        '<leader>phs',
        ':CodeSnapSaveHighlight<cr>',
        mode = 'x',
        desc = '[P]rint with [H]ighlight [S]ave',
      },
    },
    opts = {
      save_path = savePrintsTo,
      title = '',
      bg_color = '#535c68',
      watermark = 'github.com/Grsaiago',
      code_font_family = 'CaskaydiaCove Nerd Font',
      watermark_font_family = 'CaskaydiaCove Nerd Font',
      has_line_number = true,
    },
  },
}
