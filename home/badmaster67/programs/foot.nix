{lib, ...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "FiraCode Nerd Font Mono:size=12";
        pad = "4x4";
        initial-window-size-chars = "90x25";
      };
      "key-bindings" = {
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
        scrollback-up-page = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
        scrollback-up-line = "Shift+Up";
        scrollback-down-line = "Shift+Down";
        search-start = "Control+Shift+r";
        font-increase = "Control+equal";
        font-decrease = "Control+minus";
        font-reset = "Control+0";
      };
      "search-bindings" = {
        cancel = "Escape";
        commit = "Return";
        find-prev = "Control+r";
        find-next = "Control+s";
      };
    };
  };
}
