{ ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "/home/kovid/.config/hypr/sushi-dark.png"
      ];
      wallpaper = [
        {
          monitor = "";
          path = "/home/kovid/.config/hypr/sushi-dark.png";
        }
      ];
    };
  };
}
