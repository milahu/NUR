{ ... }:

{
  # XDG defines things like ~/Desktop, ~/Downloads, etc.
  # these clutter the home, so i mostly don't use them.
  sane.user.fs.".config/user-dirs.dirs".symlink.text = ''
    XDG_DESKTOP_DIR="$HOME/.xdg/Desktop"
    XDG_DOCUMENTS_DIR="$HOME/dev"
    XDG_DOWNLOAD_DIR="$HOME/tmp"
    XDG_MUSIC_DIR="$HOME/Music"
    XDG_PICTURES_DIR="$HOME/Pictures"
    XDG_PUBLICSHARE_DIR="$HOME/.xdg/Public"
    XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
    XDG_TEMPLATES_DIR="$HOME/.xdg/Templates"
    XDG_VIDEOS_DIR="$HOME/Videos"
  '';

  # prevent `xdg-user-dirs-update` from overriding/updating our config
  # see <https://manpages.ubuntu.com/manpages/bionic/man5/user-dirs.conf.5.html>
  sane.user.fs.".config/user-dirs.conf".symlink.text = "enabled=False";

  sane.user.fs.".profile".symlink.text = ''
    # configure XDG_<type>_DIR preferences (e.g. for downloads, screenshots, etc)
    # surround with `set -o allexport` since user-dirs.dirs doesn't `export` its vars
    set -a
    source $HOME/.config/user-dirs.dirs
    set +a
  '';
}
