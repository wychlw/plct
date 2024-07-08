import bs4
import requests
import os

def ver_gt(ver1: str, ver2: str):
    ver1 = tuple(map(int, ver1.split('.')))
    ver2 = tuple(map(int, ver2.split('.')))
    return ver1 > ver2

def sort_ver(ver_list: list[str]):
    def ver_key(ver: str):
        return tuple(map(int, ver.split('.')))
    ver_list.sort(key=ver_key)

def get_last_ver():
    pkgbuild_url  = 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=ruyi-bin'
    pkgbuild_content = requests.get(pkgbuild_url).text
    pkgconf = pkgbuild_content.split('\n')
    for line in pkgconf:
        if 'pkgver=' in line:
            return line.split('=')[1].strip().strip('"')
    return '0.0.0'

def get_current_ver():
    mirror_base_url = 'https://mirror.iscas.ac.cn/ruyisdk/ruyi/releases/'
    mirror_page = requests.get(mirror_base_url).text
    soup = bs4.BeautifulSoup(mirror_page, 'html.parser')
    selector = '#list > tbody > tr > td.link > a'
    links = soup.select(selector)
    ver_list = []
    for link in links:
        href = link.get('href')
        if '..' in href:
            continue
        title = link.get('title')
        ver_list.append(title)

    sort_ver(ver_list)
    return ver_list[-1]

def gen_pkgbuild(ver: str):
    pkgbuild = """
# Maintainer: Ling Wang <lingwang@wcysite.com>
pkgname=ruyi-bin
pkgver=[pkgver_placeholder]
pkgrel=1
pkgdesc="The package manager for RuyiSDK."
arch=("x86_64" "arm64" "riscv64")
url="https://github.com/ruyisdk/ruyi"
license=('Apache-2.0')
depends=('wget' 'git' 'tar' 'bzip2' 'xz' 'zstd')
provides=('ruyi=$pkgver')
options=('!strip') # !important, otherwise the binary will be broken
source_x86_64=("ruyi-$pkgver-bin::https://mirror.iscas.ac.cn/ruyisdk/ruyi/releases/$pkgver/ruyi.amd64")
source_arm64=("ruyi-$pkgver-bin::https://mirror.iscas.ac.cn/ruyisdk/ruyi/releases/$pkgver/ruyi.arm64")
source_riscv64=("ruyi-$pkgver-bin::https://mirror.iscas.ac.cn/ruyisdk/ruyi/releases/$pkgver/ruyi.riscv64")

package() {
    install -d "${pkgdir}/usr/bin"
    install -m755 "${srcdir}/ruyi-$pkgver-bin" "${pkgdir}/usr/bin/ruyi"
}
"""
    pkgbuild.replace('[pkgver_placeholder]', ver)

    with open('PKGBUILD', 'w') as f:
        f.write(pkgbuild)

    # os.mkdir('ruyi-bin')
    # os.chdir('ruyi-bin')

    # os.system('git init')
    # os.system('git remote add origin ssh://aur@aur.archlinux.org/ruyi-bin.git')
    # os.system('git pull origin master')

    # with open('PKGBUILD', 'w') as f:
    #     f.write(pkgbuild)
    
    # os.system('updpkgsums')
    # os.system('makepkg --printsrcinfo > .SRCINFO')
    # os.system('rm ruyi.*')

    # os.system('git add .')
    # os.system('git commit -m "Update to version {}"'.format(ver))
    # os.system('git push origin master')

cur_ver = get_current_ver()

gen_pkgbuild(cur_ver)
