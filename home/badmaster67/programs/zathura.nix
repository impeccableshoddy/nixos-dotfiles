{pkgs, ...}: {
  programs.zathura = {
    enable = true;
    package = pkgs.zathura.override {
      plugins = [
        pkgs.zathuraPkgs.zathura_cb
        pkgs.zathuraPkgs.zathura_pdf_poppler
        pkgs.zathuraPkgs.zathura_pdf_mupdf
      ];
    };
  };
}
