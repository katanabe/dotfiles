#!/usr/bin/env ruby
# Validates the YAML frontmatter of SKILL.md files.
# Catches issues like unquoted descriptions containing colons, which silently
# break strict YAML parsers (the symptom we hit on 2026-04-29).

require 'yaml'

failed = false

ARGV.each do |path|
  content = File.read(path)

  unless content.start_with?("---\n") || content.start_with?("---\r\n")
    next  # not frontmatter-style; skip
  end

  parts = content.split(/^---\s*$/m, 3)
  if parts.length < 3
    warn "#{path}: malformed frontmatter (no closing ---)"
    failed = true
    next
  end

  begin
    data = YAML.safe_load(parts[1])
  rescue Psych::SyntaxError => e
    warn "#{path}: YAML syntax error: #{e.message}"
    failed = true
    next
  end

  unless data.is_a?(Hash) && data['name'] && data['description']
    warn "#{path}: frontmatter missing required keys (name, description)"
    failed = true
  end
end

exit(failed ? 1 : 0)
