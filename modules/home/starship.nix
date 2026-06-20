{lib, ...}: {
  programs.starship = {
    enable = true;
    settings = lib.mkForce {
      add_newline = true;
      command_timeout = 1000;

      palette = "girl";
      palettes.girl = {
        ink = "#090910";
        slate = "#1A1B28";
        rose = "#BB8181";
        taupe = "#CD8F90";
        blush = "#F1B0B4";
        deepred = "#B83549";
      };

      format = lib.concatStrings [
        "[](ink)"
        "$hostname"
        "[](fg:ink bg:rose)"
        "$directory"
        "[](fg:rose bg:taupe)"
        "$git_branch"
        "$git_status"
        "[](fg:taupe)"
        "$nix_shell"
        "$docker_context"
        "$c"
        "$cpp"
        "$rust"
        "$golang"
        "$zig"
        "$lua"
        "$perl"
        "$php"
        "$nodejs"
        "$python"
        "$line_break"
        "$character"
      ];

      hostname = {
        ssh_only = false;
        style = "bg:ink fg:blush";
        format = "[ $hostname ]($style)";
        disabled = false;
      };

      directory = {
        style = "fg:ink bg:rose";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
        style = "fg:ink bg:taupe";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "fg:ink bg:taupe";
        format = "[($all_status$ahead_behind )]($style)";
      };

      nix_shell = {
        symbol = "❄";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $name ]($style)[](fg:slate)";
      };
      docker_context = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $context ]($style)[](fg:slate)";
        only_with_files = true;
      };
      c = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      cpp = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      rust = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      golang = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      zig = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      lua = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      perl = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      nodejs = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      php = {
        symbol = "🐘";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };
      python = {
        symbol = "";
        style = "fg:blush bg:slate";
        format = "[](fg:slate)[ $symbol $version ]($style)[](fg:slate)";
      };

      line_break.disabled = false;

      character = {
        success_symbol = "[╰─](bold fg:blush)";
        error_symbol = "[╰─](bold fg:deepred)";
      };
    };
  };
}
