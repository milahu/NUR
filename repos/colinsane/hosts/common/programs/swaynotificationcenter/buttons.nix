# icon sources:
# - <https://www.vertex42.com/ExcelTips/unicode-symbols.html>
# - <https://onlinetools.com/unicode/add-combining-characters>
# - `font-manager`
#   - this one shows all the "private use" emoji, for e.g. font Noto
# - nerd-fonts: <https://github.com/ryanoasis/nerd-fonts>
#   - grep `glyphnames.json` for the icon you want. about half of them are labeled usefully?

{ pkgs }:
let
  serviceButton = svcType: name: label: {
    inherit label;
    type = "toggle";
    command = "swaync-service-dispatcher toggle ${svcType} ${name}";
    update-command = "swaync-service-dispatcher print ${svcType} ${name}";
    active = true;
  };
in
{
  # icon sets:
  # - GPS
  #   ⌖ 🛰 🌎           󰇧  󰍒 󱋼 󰍎 󰍐 󰓾 󱘇
  # - modem
  #   📡 📱 ᯤ ⚡    🌐  📶 🗼 󰀂    󰺐  󰩯
  # - calls
  #    󰏲   󰏾   󱆗 󱆖 󰏸
  #   SIP ☏ ✆ ℡ 📞📱
  # - email
  #   ✉ [E]  E⃞    󰇰    󰻨  󰻪  󰇮  󰾱 󰶍
  #   󱡰 󱡯
  #   📧 📨 📩  📬 📫
  # - messaging
  #      󱥂  󰆁   󰆉 󰍪 󰡡 󱀢 󱗠 󱜾 󱜽 󱥁 󱗟 󰍦 󰍦 󰊌 󰿌 󰿍 󰚢 
  #       󰭻   󰋉   
  #     
  #     
  #   …⃝ Θ
  #   󰌌 ⌨   ✍
  #   💬🗨️ 📟📤 📱📲
  #   ⏏️ ⇪ ⇫ ⮸ ⭿ ⍐ ⎘
  # - XMPP
  #   󰟿  🦕 🦖
  # - Signal
  #   🔵 🗣   󰈎 󰒯 󰒰 
  # - Matrix
  #   🇲 𝐌  ₘ  m̄  m⃞  m̋⃞  M⃞  󰫺 󰬔
  # - discord
  #     󰙯 󰊴 󰺷 🎮
  gps = serviceButton "s6" "eg25-control-gps" "";
  cell-modem = serviceButton "s6" "eg25-control-powered" "󰺐";
  vpn = serviceButton "systemd" "wg-quick-vpn-servo" "vpn::hn";

  gnome-calls = serviceButton "s6" "gnome-calls" "";
  geary = serviceButton "s6" "geary" "";
  abaddon = serviceButton "s6" "abaddon" " ";
  dissent = serviceButton "s6" "dissent" " ";
  signal-desktop = serviceButton "s6" "signal-desktop" "󰭻";
  dino = serviceButton "s6" "dino" "󰟿";
  fractal = serviceButton "s6" "fractal" "[m]";
}
