-- ############################
-- ## Generated with Matugen ##
-- ############################
-- ## Manual edit is not recommended,
-- ## Except for testing.

return {
  background = "{{ background }}",
  foreground = "{{ foreground }}",
  cursor = "{{ cursor }}",

  colors = {
<* for c in colors *>    "{{ c }}",
<* endfor *>  },

  extra = {
    accent = {
      primary = "{{ extra.accent.primary }}",
      secondary = "{{ extra.accent.secondary }}",
      on_accent = "{{ extra.accent.on_accent }}",
    },

    text = {
      primary = "{{ extra.text.primary }}",
      secondary = "{{ extra.text.secondary }}",
      muted = "{{ extra.text.muted }}",
      link = "{{ extra.text.link }}",
      visited = "{{ extra.text.visited }}",
    },

    layer = {
      base = "{{ extra.layer.base }}",
      mantle = "{{ extra.layer.mantle }}",
      crust = "{{ extra.layer.crust }}",
      surface = "{{ extra.layer.surface }}",
      surface_raised = "{{ extra.layer.surface_raised }}",
      surface_overlay = "{{ extra.layer.surface_overlay }}",
    },

    border = {
      default = "{{ extra.border.default }}",
      active = "{{ extra.border.active }}",
      medium = "{{ extra.border.medium }}",
    },

    status = {
      success = "{{ extra.status.success }}",
      warning = "{{ extra.status.warning }}",
      error = "{{ extra.status.error }}",
      critical = "{{ extra.status.critical }}",
      info = "{{ extra.status.info }}",
    },

    fg = {
      dim = "{{ extra.fg.dim }}",
      dim_muted = "{{ extra.fg.dim_muted }}",
      disabled = "{{ extra.fg.disabled }}",
    },

    bg = {
      conflict = "{{ extra.bg.conflict }}",
      disk_usage = "{{ extra.bg.disk_usage }}",
    },

    syntax = {
      comment = "{{ extra.syntax.comment }}",
      keyword = "{{ extra.syntax.keyword }}",
      statement = "{{ extra.syntax.statement }}",
      ["function"] = "{{ extra.syntax.function }}",
      method = "{{ extra.syntax.method }}",
      string = "{{ extra.syntax.string }}",
      constant = "{{ extra.syntax.constant }}",
      number = "{{ extra.syntax.number }}",
      boolean = "{{ extra.syntax.boolean }}",
      type = "{{ extra.syntax.type }}",
      class = "{{ extra.syntax.class }}",
      variable = "{{ extra.syntax.variable }}",
      parameter = "{{ extra.syntax.parameter }}",
      property = "{{ extra.syntax.property }}",
      identifier = "{{ extra.syntax.identifier }}",
      operator = "{{ extra.syntax.operator }}",
      regex = "{{ extra.syntax.regex }}",
      builtin = "{{ extra.syntax.builtin }}",
      builtin_variable = "{{ extra.syntax.builtin_variable }}",
      punctuation = "{{ extra.syntax.punctuation }}",
      special = "{{ extra.syntax.special }}",
      exception = "{{ extra.syntax.exception }}",
      ["return"] = "{{ extra.syntax.return }}",
      import = "{{ extra.syntax.import }}",
      decorator = "{{ extra.syntax.decorator }}",
      tag = "{{ extra.syntax.tag }}",
      attribute = "{{ extra.syntax.attribute }}",
    },

    ui = {
      bg_statusline = "{{ extra.ui.bg_statusline }}",
      gutter = "{{ extra.ui.gutter }}",
    },
  },
}
