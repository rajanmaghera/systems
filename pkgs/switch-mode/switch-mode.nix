{writeTextFile, ...}:
writeTextFile {
  name = "switch-mode";
  text = ''
    #!/usr/bin/env osascript

    tell application "System Events"
      tell appearance preferences
          set dark mode to not dark mode
      end tell
    end tell
  '';
  executable = true;
  destination = "/bin/switch-mode";
}
