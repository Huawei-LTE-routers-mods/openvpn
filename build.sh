#!/bin/bash
set -e

export PATH="/home/valdikss/mobile-modem-router/e5372/kernel/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin:$PATH"
# Set your OpenSSL path here
OPENSSL_PATH="/home/valdikss/mobile-modem-router/openssl/git/openssl"

mkdir -p installed/huawei/{vfp3,novfp} || true


# Balong Hi6921 V7R11 (E3372h, E5770, E5577, E5573, E8372, E8378, etc) and Hi6930 V7R2 (E3372s, E5373, E5377, E5786, etc)
# softfp, vfpv3-d16 FPU
export CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -O2 -s"
export PKG_CONFIG_PATH="$OPENSSL_PATH/installed/huawei/vfp3/lib/pkgconfig/"
# -I/home/valdikss/mobile-modem-router/openssl/openssl-1.0.2p/installed_e5770/etc/ssl/include/ -L/home/valdikss/mobile-modem-router/openssl/openssl-1.0.2p/installed_e5770/etc/ssl/lib -I/home/valdikss/mobile-modem-router/openvpn/lzo/lzo-2.10/i/e5770_lzo/usr/local/include -L/home/valdikss/mobile-modem-router/openvpn/lzo/lzo-2.10/i/e5770_lzo/usr/local/lib"
make clean
./configure --host=arm-linux-gnueabi --disable-lzo --disable-lz4 --disable-plugin-auth-pam --disable-fragment \
 --disable-multihome --disable-port-share --with-crypto-library=openssl --disable-plugins \
 --enable-comp-stub --enable-iproute2 IPROUTE="/system/bin/openvpn_scripts/ip"
make "$@"

cp src/openvpn/openvpn installed/huawei/vfp3/
patchelf --set-interpreter /system/lib/glibc/ld-linux.so.3 installed/huawei/vfp3/openvpn

# Balong Hi6920 V7R1 (E3272, E3276, E5372, etc)
# soft, novfp
export CFLAGS="-march=armv7-a -mfloat-abi=soft -mthumb -O2 -s"
export PKG_CONFIG_PATH="$OPENSSL_PATH/installed/huawei/novfp/lib/pkgconfig/"
make clean
./configure --host=arm-linux-gnueabi --disable-lzo --disable-lz4 --disable-plugin-auth-pam --disable-fragment \
 --disable-multihome --disable-port-share --with-crypto-library=openssl --disable-plugins \
 --enable-comp-stub --enable-iproute2 IPROUTE="/system/bin/openvpn_scripts/ip"
make "$@"

cp src/openvpn/openvpn installed/huawei/novfp/
patchelf --set-interpreter /system/lib/glibc/ld-linux.so.3 installed/huawei/novfp/openvpn
