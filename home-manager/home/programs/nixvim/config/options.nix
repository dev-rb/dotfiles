{
  programs.nixvim.opts = {
    shell = "/bin/zsh";
    breakindent = true;
    clipboard = "unnamedplus";
    cursorline = true;
    hlsearch = true;
    inccommand = "split";
    list = true;
    # listchars = "tab:⇥ ,trail:·,nbsp:␣,space:·";
    fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:";
    mouse = "a";
    number = true;
    relativenumber = false;
    scrolloff = 15;
    sessionoptions = [
      "buffers"
      "curdir"
      "tabpages"
      "winsize"
      "help"
      "globals"
      "skiprtp"
      "folds"
    ];
    showmode = false;
    signcolumn = "yes";
    smartcase = true;
    splitbelow = true;
    splitright = true;
    timeoutlen = 300;
    undofile = true;
    updatetime = 250;
    termguicolors = true;
    shiftwidth = 2;
    tabstop = 2;
    expandtab = true;
  };
}
