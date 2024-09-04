# preferences are saved via dconf; see `dconf dump /`
# cache dir is just for weather data (or maybe a http cache)
{ ... }:
{
  sane.programs.gnome-weather = {
    buildCost = 1;

    sandbox.method = "bunpen";
    sandbox.wrapperType = "inplace";  #< /share/org.gnome.Weather/org.gnome.Weather file refers to bins by full path
    sandbox.whitelistWayland = true;
    sandbox.net = "clearnet";
    suggestedPrograms = [ "dconf" ];  #< stores city/location settings

    persist.byStore.plaintext = [
      ".cache/libgweather"
    ];
  };
}
