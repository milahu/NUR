{ ... }:
{
  services.caddy.virtualHosts = {
    "violingifts.com" = {
      serverAliases = [
        "www.violingifts.com"
        "www.theviolincase.com"
        "shop.theviolincase.com"
      ];
      vacu.hsts = true;
      extraConfig = "redir https://theviolincase.com{uri}";
    };
    "theviolincase.com" = {
      vacu.hsts = true;
      extraConfig = ''
        header Content-Type "text/html; charset=utf-8"
        respond 200 {
          body <<EOF
            <!doctype html>
            <html>
              <head>
                <title>TVC Tombstone</title>
              </head>
              <body>
                <div id="tombstone">
                  Here Lies<br>
                  TheViolinCase.com<br>
                  <small>a.k.a. ViolinGifts.com</small><br>
                  2001 - 2019<br>
                </div>
              </body>
            </html>
            EOF
        }
      '';
    };
  };
}
