{
  lib,
  buildGoPackage,
  fetchFromGitea,
}:

buildGoPackage {
  pname = "gemcert";
  version = "2020-08-01";

  src = fetchFromGitea {
    domain = "tildegit.org";
    owner = "solderpunk";
    repo = "gemcert";
    rev = "fc14deb2751274d2df01f8d5abef023ec7e12a8c";
    hash = "sha256-za3pS6WlOJ+NKqhyCfhlj7gH4U5yFXtJ6gLta7WXhb0=";
  };

  goPackagePath = "tildegit.org/solderpunk/gemcert";

  meta = with lib; {
    description = "A simple tool for creating self-signed certs for use in Geminispace";
    homepage = "https://tildegit.org/solderpunk/gemcert";
    license = licenses.bsd2;
    maintainers = [ maintainers.sikmir ];
    platforms = platforms.unix;
    mainProgram = "gemcert";
  };
}
