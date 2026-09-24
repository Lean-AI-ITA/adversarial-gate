# Adversarial Gate — demo recording
#
# Produces the README GIF from a REAL session, not a mockup.
#   brew install charmbracelet/tap/vhs   (or: go install github.com/charmbracelet/vhs@latest)
#   vhs assets/demo.tape
#
# Record the actual contradictory review. If you script a fake one, someone
# will notice, and credibility is the only thing this project is selling.

Output assets/contradictory-review.gif

Set FontFamily "JetBrains Mono"
Set FontSize 20
Set Width 1600
Set Height 900
Set Padding 40
Set Theme { "background": "#1a2b3c", "foreground": "#e8eef3", "cursor": "#16a085", "black": "#1a2b3c", "red": "#e74c3c", "green": "#28c840", "yellow": "#febc2e", "blue": "#2e7d8f", "magenta": "#8e44ad", "cyan": "#16a085", "white": "#e8eef3" }
Set BorderRadius 12
Set Margin 30
Set MarginFill "#131c26"
Set Shell "bash"
Set TypingSpeed 45ms
Set PlaybackSpeed 1.0

Hide
Type "clear" Enter
Show

Sleep 800ms

# --- the objection ---
Type "I don't think you need three agents for this. It's a CRUD app."
Sleep 600ms
Enter

# Let the real response stream. Tune this to your actual latency:
# too short and it cuts off, too long and nobody watches to the end.
Sleep 14s

# --- the user concedes, the gate still refuses to move ---
Type "Fair."
Sleep 400ms
Enter

Sleep 6s

# --- hold on the approval gate: this is the frame that sells the project ---
Sleep 3s
