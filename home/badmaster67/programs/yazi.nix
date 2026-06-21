{...}: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      mgr = {
        sort_by = "mtime";
        sort_reverse = true;
        sort_dir_first = true;
      };
      opener = {
        pdf = [
          {
            run = "zathura \"$@\"";
            desc = "zathura";
          }
        ];
      };
      open = {
        rules = [
          {
            mime = "application/pdf";
            use = "pdf";
          }
          {
            mime = "application/epub+zip";
            use = "pdf";
          }
        ];
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["g" "c"];
          run = "cd ~/nixos-dotfiles";
          desc = "Go dotfiles";
        }
        {
          on = ["g" "D"];
          run = "cd ~/Documents";
          desc = "Go Documents";
        }
      ];
    };
  };
}
