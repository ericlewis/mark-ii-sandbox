set -e
export DEBIAN_FRONTEND=noninteractive

echo "Updating and installing packages..."
apt-get update
apt-get install --yes --no-install-recommends \
  build-essential python3-venv python3-dev python3-smbus \
  i2c-tools alsa-utils

echo "Copying files and directories..."
mkdir -p /usr/local/mycroft/mark-2/
cp -r vocalfusion/* /usr/local/mycroft/mark-2/

echo "Copying ALSA config..."
cp vocalfusion/vocalfusion-rpi-setup-5.2.0/resources/asoundrc_vf_xvf3510_int \
  /etc/alsa/conf.d/20-xmos.conf

echo "Copying systemd service..."
cp vocalfusion/etc/mark2-microphone.service \
  /etc/systemd/system/

echo "Enabling i2c..."
echo 'i2c-dev' >> /etc/modules

echo "Copying system files..."
cp -r files/* /

echo "Installing DBus HAL..."
cp -r dbus-hal /usr/local/mycroft/mark-2/dbus-hal/
cd /usr/local/mycroft/mark-2/dbus-hal/ && \
  ./install.sh

echo "Enabling services..."
systemctl enable mark2-microphone.service
systemctl enable mark2-hal.service
systemctl enable mark2-boot.service

echo "Cleaning up..."
apt-get clean
apt-get autoremove --yes
rm -rf /var/lib/apt/lists/*

echo "Setup complete. Reboot to complete process."
