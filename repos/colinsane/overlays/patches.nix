final: prev: {
  slurp = if final.lib.versionAtLeast prev.slurp.version "1.5.1" then
    final.lib.warnOnInstantiate "new slurp screenshotter may fail: test before committing" prev.slurp
  else
    prev.slurp
  ;
  # slurp = prev.slurp.overrideAttrs (upstream: {
  #   # 2026-01-27: disable the slurp-specific lockfile, as it reliably fails if WAYLAND_DISPLAY contains a `/`.
  #   # see: <https://github.com/emersion/slurp/issues/188>
  #   # (not sure why my screenshotter would need a lockfile??)
  #   postPatch = (upstream.postPatch or "") + ''
  #     substituteInPlace main.c --replace-fail \
  #       'acquire_lock()' 'true'
  #   '';
  # });
}
