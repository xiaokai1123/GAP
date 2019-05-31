#!/bin/sh
#author: eason.lian

usage_brief() {
    echo -e "\nUsage: source ${PROGNAME} <meta-project> <machine> [builddir]\n"
}

clean_up()
{
    unset TOPDIR LISTGIT PROJECTDIR OPENLAYERSDIR USERLAYERSDIR VERCONFDIR EXTERNALDIR PROGNAME
    unset OEROOT BRANCH DISTRO DISTRO_DEFAULT MACHINE MACHINE_DEFAULT VER_CONF_FILE
}

#args1: key word
#args2: file path
update_local_conf()
{
    if [ x"${1}" = "x" ]; then
        return 1
    fi
    #delete & new insert
    KEY=`echo ${1} | awk '{print $1}'`
    KEY_PREFIX=`echo ${1} | awk '{print substr($0,1,1)}'`
    if [ x"$KEY_PREFIX" = x"#" ]; then
        KEY=${KEY#*#}
        return 1
    fi
    sed -i "/$KEY/d" ${2}
    echo ${1} >> ${2}
}

#args1: key word
#args2: file path
update_bblayers_conf()
{
    #delete & new insert
    KEY_PREFIX=`echo ${1} | awk '{print substr($0,1,1)}'`
    if [ x"$KEY_PREFIX" = x"#" ]; then
        return 1
    fi
    echo ${1} >> ${2}
}

get_list_git()
{
    for name in ${EXTERNALDIR}/*
    do
        temp=`basename ${name}`
        if [ x"git" = x"${temp#*.}" ]; then
            temp=`basename ${name%.*}`
            LISTGIT="${LISTGIT} $temp"
        fi
    done
}

#args1: git name
#args2: branch name
local_fetch()
{
    if [ "$#" != 2 ]; then
        echo "args illegal!"
        return 1
    fi
    DESTDIR=${OPENLAYERSDIR}

    if [ ! -d ${EXTERNALDIR}/${1}.git ]; then
        echo "No found valid remote git(${EXTERNALDIR}/${1}.git)!"
        return 1
    fi

    mkdir -p ${DESTDIR}
    if [ x"${1}" = x"poky" -a ! -f ${EXTERNALDIR}/${POKYMERGE} ]; then
        cat ${EXTERNALDIR}/${POKYSPLIT} > ${EXTERNALDIR}/${POKYMERGE} 
    fi

    if [ ! -d ${DESTDIR}/${1}/.git ]; then
        cd ${DESTDIR}
        git clone file://${EXTERNALDIR}/${1}.git
        cd ${1}
        ck=`git branch -a | grep remotes/origin/${2} | wc -l`
        if [ "$ck" = "0" ]; then
            git checkout master
        else
            git checkout ${2}
        fi
    else
        cd ${DESTDIR}/${1}
        ck=`git branch -a | grep remotes/origin/${2} | wc -l`
        if [ "$ck" = "0" ]; then
            git checkout master >/dev/null 2>&1
        else
            git checkout ${2} >/dev/null 2>&1
        fi
    fi
}

PROGNAME="setup.sh"

TOPDIR=`pwd`

OPENLAYERSDIR=${TOPDIR}/.open-layers
OPENEMBEDDEDDIR=${OPENLAYERSDIR}/meta-openembedded
USERLAYERSDIR=${TOPDIR}
EXTERNALDIR=${TOPDIR}/.external
POKYSPLIT=poky.git/objects/pack/pack-4115f87bef97b298fd0c5c9f0b74bb4dafdc4979.a*
POKYMERGE=poky.git/objects/pack/pack-4115f87bef97b298fd0c5c9f0b74bb4dafdc4979.pack

LISTGIT=

if [ "$0" = "./${PROGNAME}" ]; then
    usage_brief
    clean_up
    exit 1
fi

if [ "$(whoami)" = "root" ]; then
    echo -e "\nERROR: do not use as root. Exiting..."
    usage_brief
    clean_up
    return 1
fi

if [ -z $BRANCH ]; then
    BRANCH="sumo"
fi

get_list_git

for name in ${LISTGIT}
do
    if [ x"$name" = x"meta-selinux" ]; then
        local_fetch $name sumo
    else
        local_fetch $name $BRANCH
    fi
done
cd $TOPDIR

if [ "$#" -lt "1" ]; then
    usage_brief
    clean_up
    return 1
fi

_VAR=$1
OEROOT=${OPENLAYERSDIR}/poky
PROJECTDIR=${USERLAYERSDIR}/${_VAR%/*}
unset _VAR
VERCONFDIR=${PROJECTDIR}/ver-confs
if [ ! -d ${PROJECTDIR} ]; then
    echo -e "\nERROR: not exsit Layer ${PROJECTDIR}. Exiting..."
    clean_up
    return 1
fi
if [ -f ${PROJECTDIR}/conf/extra.sh ]; then
    cd ${PROJECTDIR}/conf/ && sh extra.sh
fi
cd $TOPDIR

if [ -d "${PROJECTDIR}/conf/distro" ]; then
    DISTROLIST=`ls ${PROJECTDIR}/conf/distro/*.conf | sed s/\.conf//g | sed -r 's/^.+\///'`
fi
if [ -z "${DISTROLIST}" ]; then
    DISTRO_DEFAULT="poky"
else
    DISTRO_DEFAULT=`echo ${DISTROLIST} | awk '{print $1}'`
fi
if [ ! -z "${DISTRO}" ]; then
    DISTRO_DEFAULT=${DISTRO}
fi

if [ -d "${PROJECTDIR}/conf/machine" ]; then
    MACHINELIST=`ls ${PROJECTDIR}/conf/machine/*.conf | sed s/\.conf//g | sed -r 's/^.+\///'`
else
    echo -e "\nERROR: not exsit ${PROJECTDIR}/conf/machine. Exiting..."
    clean_up
    return 1
fi
if [ -z "${MACHINELIST}" ]; then
    echo -e "\nERROR: not exsit machine.conf. Exiting..."
    clean_up
    return 1
fi

if [ "$#" -lt "2" ]; then
    echo -e "\nNote: Layer ${PROJECTDIR} machine support < `echo ${MACHINELIST}` >.Please select one machine for configure."
    usage_brief
    clean_up
    return 1
fi

for mac in ${MACHINELIST}; do
    if [ x"$2" = x"$mac" ]; then
        match_flag="1";
        MACHINE_DEFAULT=$mac
        break;
    else
        match_flag="0";
    fi
done
if [ "$match_flag" = "0" ]; then
    echo -e "\nERROR: machine ${2} not support in Layer ${PROJECTDIR}.Current support < `echo ${MACHINELIST}` >.Exiting..."
    clean_up
    return 1
fi

if [ "$#" = 2 ]; then
    BUILDDIR=${TOPDIR}/build_$2
else
    BUILDDIR=${TOPDIR}/$3
fi

if [ "$#" = 4 ]; then
    IMAGE_VERSION=$4
else
    IMAGE_VERSION=V1.2.1
fi


if [ -d ${BUILDDIR}/conf/ ]; then
    rm -rf ${BUILDDIR}/conf/*
fi

cd $OEROOT
. ./oe-init-build-env ${BUILDDIR} > /dev/null

# if conf/local.conf not generated, no need to go further
if [ ! -e ${BUILDDIR}/conf/local.conf ]; then
    clean_up && return 1
fi

cd ${BUILDDIR}

if [ ! -e conf/local.conf.sample ]; then
    mv conf/local.conf conf/local.conf.sample

    touch conf/local.conf
fi

if [ -e ${PROJECTDIR}/conf/local.conf ]; then
    update_local_conf "DISTRO = \"$DISTRO_DEFAULT\"" ${BUILDDIR}/conf/local.conf
    update_local_conf "MACHINE = \"$MACHINE_DEFAULT\"" ${BUILDDIR}/conf/local.conf
    update_local_conf "PACKAGE_CLASSES = \"package_rpm\"" ${BUILDDIR}/conf/local.conf
    update_local_conf "EXTRA_IMAGE_FEATURES = \"debug-tweaks\"" ${BUILDDIR}/conf/local.conf
    update_local_conf "USER_CLASSES = \"buildstats image-mklibs image-prelink\"" ${BUILDDIR}/conf/local.conf
    update_local_conf "PATCHRESOLVE = \"noop\"" ${BUILDDIR}/conf/local.conf
    update_local_conf "CONF_VERSION = \"1\"" ${BUILDDIR}/conf/local.conf
    #update_local_conf "DL_DIR = \"${BUILDDIR}/tmp/downloads\"" ${BUILDDIR}/conf/local.conf
    #update_local_conf "SSTATE_DIR = \"${BUILDDIR}/tmp/sstate-cache\"" ${BUILDDIR}/conf/local.conf
    cat ${PROJECTDIR}/conf/local.conf | while read content
    do
        update_local_conf "$content" ${BUILDDIR}/conf/local.conf
    done
else
    # Generate the local.conf based on the Yocto defaults
    #not resolve here with update_local_conf
    sed -i '/BB_DISKMON_DIRS/,+7d' conf/local.conf.sample
    grep -v '^#\|^$' conf/local.conf.sample > conf/local.conf
fi
update_local_conf "IMAGE_VERSION = \"${IMAGE_VERSION}\"" ${BUILDDIR}/conf/local.conf
if [ x"$BRANCH" = x"sumo" ]; then
    update_local_conf "SOURCE_MIRROR_URL = \"file:///opt/mirror_downloads_sumo/\"" ${BUILDDIR}/conf/local.conf
    update_local_conf "SSTATE_MIRRORS = \"file://.* file:///opt/sstate-cache-sumo-${2}/PATH\"" ${BUILDDIR}/conf/local.conf
else
    update_local_conf "SOURCE_MIRROR_URL = \"file:///opt/mirror_downloads/\"" ${BUILDDIR}/conf/local.conf
    update_local_conf "SSTATE_MIRRORS = \"file://.* file:///opt/sstate-cache-${2}/PATH\"" ${BUILDDIR}/conf/local.conf
fi
update_local_conf "INHERIT += \"own-mirrors\"" ${BUILDDIR}/conf/local.conf
update_local_conf "BB_GENERATE_MIRROR_TARBALLS = \"1\"" ${BUILDDIR}/conf/local.conf
update_local_conf "CONNECTIVITY_CHECK_URIS = \"\"" ${BUILDDIR}/conf/local.conf

if [ -z $VER_CONF_FILE ]; then
    VER_CONF_FILE="$2-default.conf"
fi
if [ -f "${VERCONFDIR}/${VER_CONF_FILE}" ]; then
    update_local_conf "VER_CONF_FILE = \"${VERCONFDIR}/${VER_CONF_FILE}\"" ${BUILDDIR}/conf/local.conf
fi

if [ -e ${BUILDDIR}/conf/bblayers.conf ]; then
    echo "BBLAYERS += \"${PROJECTDIR}\"" >> ${BUILDDIR}/conf/bblayers.conf
fi
if [ -e ${PROJECTDIR}/conf/bblayers.conf ]; then
    cat ${PROJECTDIR}/conf/bblayers.conf | while read content
    do
        update_bblayers_conf "$content" ${BUILDDIR}/conf/bblayers.conf
    done
    sed -e "s|##TOPDIR##|$TOPDIR|g" -i ${BUILDDIR}/conf/bblayers.conf
    sed -e "s|##OPENEMBEDDEDDIR##|$OPENEMBEDDEDDIR|g" -i ${BUILDDIR}/conf/bblayers.conf
fi

if [ -e ${PROJECTDIR}/conf/conf-notes.txt ]; then
    cat ${PROJECTDIR}/conf/conf-notes.txt
fi

clean_up
