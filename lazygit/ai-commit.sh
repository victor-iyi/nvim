#!/bin/sh
# Writes a commit message for the staged changes with Claude straight into lazygit's own commit
# box: lazygit keeps an unfinished message in .git/LAZYGIT_PENDING_COMMIT and loads it (summary
# and description) the next time the commit box opens. Inside Neovim the box then opens by
# itself; elsewhere press `c`. Used by lazygit's <c-a> in the Files panel (see config.yml).

MODEL=${AI_COMMIT_MODEL:-claude-sonnet-5-5}

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code is not installed (https://claude.com/claude-code)" >&2
  exit 1
fi

if git diff --cached --quiet; then
  echo "Nothing is staged: stage changes with <space> first" >&2
  exit 1
fi

git_dir=$(git rev-parse --absolute-git-dir) || exit 1
pending="$git_dir/LAZYGIT_PENDING_COMMIT"
message_file="$git_dir/AI_COMMIT_EDITMSG"

SYSTEM_PROMPT='You write the git commit message for the staged changes you are given.

DEFAULT FORMAT (use it unless the repository has its own clear convention, see below):
- First line: Conventional Commits, `<type>(<optional scope>): <description>`, e.g. feat:, fix:,
  refactor:, docs:, chore:, release: (also test:, perf:, build:, ci:, style: where they fit).
  Under 50 characters, imperative mood, lowercase description, no trailing period.
- Then one blank line.
- Then a bulleted list, each bullet starting with "- ", detailing the specific changes in the
  staged diff.

REPOSITORY CONVENTION (this decides):
- Study the recent commits you are given. Where the project clearly follows its own
  convention, follow it: subject style (Conventional Commits or not, capitalisation,
  gitmoji, ticket or component prefixes, the scopes it uses, length), and body style (bullets,
  prose, wrapping, trailers such as Signed-off-by).
- Conventions change. Weigh the newest commits most: if the latest commits have adopted a new
  convention, follow the new one, not the older history.
- Where the history is mixed, sparse or silent on something (for example, past commits have no
  bodies), use the default format for that part.

ALWAYS:
- Describe what the diff actually changes, and why when the diff makes it clear. Be specific;
  no filler, no restating file names without saying what changed in them.
- Pick the type and scope that fit this change; reuse scopes the history already uses.
- Wrap body lines at 72 characters.
- Output only the commit message: no code fences, quotes, preamble or notes.'

{
  echo "Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  echo
  echo "Recent commit subjects, newest first:"
  git log -n 30 --no-merges --format='%s' 2>/dev/null
  echo
  echo "Full messages of the latest commits, newest first:"
  git log -n 6 --no-merges --format='--- commit%n%B' 2>/dev/null
  echo
  echo "Staged changes:"
  git diff --cached --no-color --no-ext-diff --stat
  echo
  git diff --cached --no-color --no-ext-diff | head -c 150000
} >"$message_file.prompt"


if ! claude -p --model "$MODEL" --tools "" --no-session-persistence --system-prompt "$SYSTEM_PROMPT" \
  <"$message_file.prompt" >"$message_file.raw" 2>&1; then
  cat "$message_file.raw" >&2
  rm -f "$message_file.prompt" "$message_file.raw"
  echo >&2
  echo "Claude failed. If it says 'Not logged in', run \`claude\` once and type /login." >&2
  exit 1
fi

# Drop code fences the model may add anyway, and blank lines at the start and end.
grep -v '^[[:space:]]*```' "$message_file.raw" |
  awk 'NF { started = 1 } started' |
  awk '{ lines[NR] = $0 } NF { last = NR } END { for (i = 1; i <= last; i++) print lines[i] }' \
    >"$message_file"
rm -f "$message_file.prompt" "$message_file.raw"

if [ ! -s "$message_file" ]; then
  rm -f "$message_file"
  echo "Claude returned no message." >&2
  exit 1
fi

mv "$message_file" "$pending"

# Inside Neovim, have it press `c` in lazygit once this command has finished (see `ai/lazygit.lua`).
if [ -n "$NVIM" ] && command -v nvim >/dev/null 2>&1; then
  nvim --server "$NVIM" --remote-expr "v:lua.require'ai.lazygit'.open_commit_box('$pending')" >/dev/null 2>&1
fi
