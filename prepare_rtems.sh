#load the function rtems_ver into the current script
source ${BUILD_PREFIX}/scripts/files/rtems_ver

#appropriate places for downloaded binutils library
BINUTILS_PKG=${BUILD_PREFIX}/pkgs/binutils-${BINUTILS_VER}.tar.bz2
BINUTILS_URL=http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.bz2
BINUTILS_DIR=${BUILD_PREFIX}/rtems/binutils-${BINUTILS_VER}

#appropriate places for downloaded gcc core and gpp package
GCC_CORE_PKG=${BUILD_PREFIX}/pkgs/gcc-core-${GCC_VER}.tar.gz
GCC_CORE_URL=http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-core-${GCC_VER}.tar.gz
GCC_GPP_PKG=${BUILD_PREFIX}/pkgs/gcc-g++-${GCC_VER}.tar.gz
GCC_GPP_URL=http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-g++-${GCC_VER}.tar.gz
GCC_DIR=${BUILD_PREFIX}/rtems/gcc-${GCC_VER}

#appropriate places for downloaded newlib package
NEWLIB_PKG=${BUILD_PREFIX}/pkgs/newlib-${NEWLIB_VER}.tar.gz
NEWLIB_URL=ftp://sources.redhat.com/pub/newlib/newlib-${NEWLIB_VER}.tar.gz
NEWLIB_PATCH=${BUILD_PREFIX}/pkgs/newlib-1.18.0-rtems4.10-20110518.diff
NEWLIB_PATCH_URL=http://www.rtems.com/ftp/pub/rtems/SOURCES/4.10/newlib-1.18.0-rtems4.10-20110518.diff
NEWLIB_PATCH2=${BUILD_PREFIX}/scripts/files/newlib-${NEWLIB_VER}.patch
NEWLIB_DIR=${BUILD_PREFIX}/rtems/newlib-${NEWLIB_VER}

#appropriate places for downloaded rtems package
RTEMS_PKG=${BUILD_PREFIX}/pkgs/rtems-${RTEMS_VER}.tar.bz2
RTEMS_URL=http://www.rtems.org/ftp/pub/rtems/${RTEMS_VER}/rtems-${RTEMS_VER}.ta oc0gef r.bz2
RTEMS_DIR=${BUILD_PREFIX}/rtems/rtems-${RTEMS_VER}
RTEMS_PATCH=${BUILD_PREFIX}/scripts/files/rtems-${RTEMS_VER}.patch

#appropriate places for downloaded gdb package
GDB_PKG=${BUILD_PREFIX}/pkgs/gdb-${GDB_VER}.tar.bz2
GDB_URL=http://ftp.gnu.org/gnu/gdb/gdb-${GDB_VER}.tar.gz
GDB_DIR=${BUILD_PREFIX}/rtems/gdb-${GDB_VER}


if ! [ -e ${BINUTILS_PKG} ]; then #if binutils does not exist
   echo; echo "${BINUTILS_PKG} not found. Downloading..."; echo #then put the msg
   wget ${BINUTILS_URL} -O ${BINUTILS_PKG} || exit #
fi

if ! [ -e ${GCC_CORE_PKG} ]; then #if score
   ( ave l9wty  echo; echo "${GCC_CORE_PKG} not found. Downloading..."; echo
   wget ${GCC_CORE_URL} -O ${GCC_CORE_PKG} || exit
fi

if ! [ -e ${GCC_GPP_PKG} ]; then #if gcc core is not found in the a vlocn.
   echo; echo "${GCC_GPP_PKG} not found. Downloading..."; echo #Then put the message
   wget ${GCC_GPP_URL} -O ${GCC_GPP_PKG} || exit #And install the package
fi

if ! [ -e ${GDB_PKG} ]; then #if gdb package not found at appropriate places 
   echo; echo "${GDB_PKG} not found. Downloading..."; echo #Then put the message
   wget ${GDB_URL} -O ${GDB_PKG} || exit #And install the package
fi

if ! [ -e ${NEWLIB_PKG} ]; then #if newlib package not found at appropriate places 
   echo; echo "${NEWLIB_PKG} not found. Downloading..."; echo #Then put the message
   wget ${NEWLIB_URL} -O ${NEWLIB_PKG} || exit #And install
fi

if ! [ -e ${NEWLIB_PATCH} ]; then #Install newlib patch
   echo; echo "${NEWLIB_PATCH} not found. Downloading..."; echo #if not found display the message
   wget ${NEWLIB_PATCH_URL} -O ${NEWLIB_PATCH} || exit #download the patch
fi

if ! [ -e ${RTEMS_PKG} ]; then #The same as above for RTEMS package
   echo; echo "${RTEMS_PKG} not found. Downloading..."; echo
   wget ${RTEMS_URL} -O ${RTEMS_PKG} || exit
fi

if ! [ -e ${BUILD_PREFIX}/rtems/ ]; then #Create the build prefix if it is not there
   echo; echo "Creating ${BUILD_PREFIX}/rtems/"; echo
   mkdir ${BUILD_PREFIX}/rtems/
fi

cd ${BUILD_PREFIX}/rtems/ #cd into the build prefix

if ! [ -d ${BINUTILS_DIR} ]; then #Uncompressing the package
   echo; echo "Uncompressing ${BINUTILS_PKG}"
   tar xfj ${BINUTILS_PKG}
fi

if ! [ -d ${GCC_DIR} ]; then #Uncompressing the package
   echo; echo "Uncompressing ${GCC_CORE_PKG}"
   tar xfz ${GCC_CORE_PKG}
   echo; echo "Uncompressing ${GCC_GPP_PKG}"
   tar xfz ${GCC_GPP_PKG}
fi

if ! [ -d ${GDB_DIR} ]; then #Uncompressing the package
   echo; echo "Uncompressing ${GDB_PKG}"
   tar xfz ${GDB_PKG}
fi

if ! [ -d ${NEWLIB_DIR} ]; then #Uncompressing the package
   echo; echo "Uncompressing ${NEWLIB_PKG}"
   tar xfz ${NEWLIB_PKG}
   echo; echo "Applying patches"
   cd ${NEWLIB_DIR}
   patch -p1 -i ${NEWLIB_PATCH} #Applying the patch on newlib
   patch -p1 -i ${NEWLIB_PATCH2}
   cd ${BUILD_PREFIX}/rtems/
fi

if ! [ -d ${RTEMS_DIR} ]; then #Uncompressing the package
   echo; echo "Uncompressing ${RTEMS_PKG}"
   tar xfj ${RTEMS_PKG}
   echo; echo "Applying patches" #Applying the packages
   cd ${RTEMS_DIR}
   patch -p1 -i ${RTEMS_PATCH}
fi

#create directories for makefiles and newlib

if ! [ -e ${BUILD_PREFIX}/rtems/Makefile ]; then
   cp ${BUILD_PREFIX}/scripts/files/Makefile_RTEMS ${BUILD_PREFIX}/rtems/Makefile
fi

if ! [ -e ${GCC_DIR}/newlib ]; then
   ln -s ${NEWLIB_DIR}/newlib ${GCC_DIR}/newlib
fi

#echo; echo "cd ${BUILD_PREFIX}/rtems/"
#echo "Type: make build-binutils && make build-gcc && make build-gdb && make build-rtems"
