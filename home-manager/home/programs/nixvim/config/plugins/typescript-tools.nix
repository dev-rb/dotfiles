{
  programs.nixvim = {
    plugins.typescript-tools = {
      enable = true;
      settings = {
        exposeAsCodeAction = "all";
        tsserverPath = "/home/dev-rb/.local/share/pnpm/global/5/node_modules/typescript/lib/tsserver.js";
      };
    };
  };
}
