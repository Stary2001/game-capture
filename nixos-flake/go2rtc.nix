{...}: {
  services.go2rtc = {
    enable = true;
    settings = {
      streams = {
        test = "ffmpeg:device?video=/dev/v4l/by-id/usb-MACROSILICON_USB_Video-video-index0&resolution=1920x1080&input_format=mjpeg#video=copy";
      };
    };
  };
}
