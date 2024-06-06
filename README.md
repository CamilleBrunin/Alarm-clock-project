# Alarm-clock-project
This project was developed to run a radio-alarm clock app on a Raspberry Pi3

### User manual

The application building and running on the Raspberry Pi3 were possible thanks to the flutter-pi package https://github.com/ardera/flutter-pi.

**Step 0** (to do only once): install flutter-pi on the Raspberry Pi, and install flutter_pi dart tool on the devlopment machine (Linux here).

**Step 1**: build the app on the development machine thanks to the following command:
> flutterpi_tool build --arch=arm64 --cpu=pi3 --release

**Step 2**: transfer the output directory to the raspberry (/build/flutter_assets/)

**Step 3**: configure the Raspberry in console mode to be able to use the display (HDMI) output for the app rendering:
> sudo raspi-config

System Options -> Boot / Auto Login -> Console
(save and reboot)

**Step 4**: run the app on the Raspberry thanks to the following command:
> flutter-pi --release *path_to_the_build_output_foler*