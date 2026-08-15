(self: super:
  let
    patchedPam = super.linux-pam.overrideAttrs (old: {
      # Replace upstream patch, this is fragile and may break in the future
      # https://github.com/nix-community/home-manager/issues/7027
      postPatch = ''
        substituteInPlace modules/module-meson.build \
          --replace-fail "sbindir / 'unix_chkpwd'" "'/usr/bin/unix_chkpwd'"
      '';
    });

  in { hyprlock = super.hyprlock.override { pam = patchedPam; }; })
