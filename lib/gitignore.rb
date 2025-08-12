def setup_gitignore(include_tailwind: false)
  ignore_entries = [
    "/spec/vcr_cassettes",
    "",
    ".env",
    ".env.local",
    ".env.*.local",
    "",
    ".vscode/",
    ".idea/",
    "",
    ".DS_Store",
    "",
    "/coverage/"
  ]

  if include_tailwind
    ignore_entries += [
      "",
      "/app/assets/builds/*",
      "!/app/assets/builds/.keep"
    ]
  end

  append_to_file '.gitignore', <<~TEXT

    #{ignore_entries.join("\n")}
  TEXT
end