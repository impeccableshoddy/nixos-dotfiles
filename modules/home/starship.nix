{lib, ...}: {
  programs.starship = {
    enable = true;
    settings = lib.mkForce {
      add_newline = true;
      command_timeout = 1000;

      palette = "girl";
      palettes.girl = {
        bg = "#222222";
        bg2 = "#2a2a2a";
        accent = "#ffa133";
        accent2 = "#cc8128";
        text = "#d4d4d4";
        dim = "#5a5a5a";
        critical = "#ff5a3c";
      };

      format = lib.concatStrings [
        "[](bg)"
        "$hostname"
        "[](fg:bg bg:accent)"
        "$directory"
        "[](fg:accent bg:accent2)"
        "$git_branch"
        "$git_status"
        "[](fg:accent2)"
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
        style = "bg:bg fg:text";
        format = "[ $hostname ]($style)";
        disabled = false;
      };

      directory = {
        style = "fg:bg bg:accent";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
        style = "fg:bg bg:accent2";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "fg:bg bg:accent2";
        format = "[($all_status$ahead_behind )]($style)";
      };

      nix_shell = {
        symbol = "❄";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $name ]($style)[](fg:bg2)";
      };
      docker_context = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $context ]($style)[](fg:bg2)";
        only_with_files = true;
      };
      c = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      cpp = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      rust = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      golang = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      zig = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      lua = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      perl = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      nodejs = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      php = {
        symbol = "🐘";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };
      python = {
        symbol = "";
        style = "fg:accent bg:bg2";
        format = "[](fg:bg2)[ $symbol $version ]($style)[](fg:bg2)";
      };

      line_break.disabled = false;

      character = {
        success_symbol = "[╰─](bold fg:accent)";
        error_symbol = "[╰─](bold fg:critical)";
      };
    };
  };
}
