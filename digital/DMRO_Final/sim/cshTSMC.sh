source /usr/local/cds2008/env/ic.cshrc
set path = ( /usr/local/cds2008/wrapper \
	 /usr/local/synopsys/wrapper \
	 /usr/local/cds2008/pve/bin \
	 /usr/local/cds2008/pve/tools/bin \
	 $path)
#setenv AMSHOME $IUS
setenv AMSHOME /usr/local/cds2008/INCISIV131
setenv LDV_HOME $AMSHOME
setenv EUREKA_PATH $AMSHOME
setenv NV_INST_DIR $AMSHOME
setenv INC_LIBS $AMSHOME/tools/lib
#setenv OPTION 1p6m3x1z1u
setenv OPTION 1p9m6x1z1u
setenv PDK_PATH /usr/local/TSMC65nm
#setenv PDK_PATH /users/dtgong/TSMC65PDK/Base_PDK
setenv TECHDIR /users/liu/workarea/lpGBT/Calibre
setenv MGLS_LICENSE_FILE 1717@genuse32.seas.smu.edu
#setenv MGC_HOME /usr/local/mentor/ixl_cal_2015.1_26.16
setenv MGC_HOME /usr/local/mentor/aoi_cal_2016.4_15.11
setenv PDK_RELEASE V1.7A_1
setenv QRC_ENABLE_EXTRACTION t
setenv pvs_source_added_place TRUE
#setenv TSMC_PDK $PDK_PATH/V1.7A_1/1p6m3x1z1u
setenv TSMC_PDK $PDK_PATH/V1.7A_1/1p9m6x1z1u
setenv ICHOME $CDSHOME
setenv TSMC_DIG_LIBS $PDK_PATH/digital
setenv CDS_TMP_DIR /tmp/$USER/cds/tmp
setenv DRCTEMPDIR /tmp/$USER/cds/DRCTEMPDIR
setenv PVEHOME /usr/local/cds2008/pve
setenv QRCHOME /usr/local/cds2008/pve
setenv PV_COLOR_DIR /usr/local/cds2008/pve/tools/pvs/samples/color_setup/for_pvs_install
setenv CLIOSOFT_DIR /usr/local/clio/sos_6.32.p3_linux
setenv CDS_AUTO_64BIT ALL
echo $CLIOSOFT_DIR
setenv LD_LIBRARY_PATH $CLIOSOFT_DIR/lib:$CLIOSOFT_DIR/lib/64bit:$LD_LIBRARY_PATH
echo $LD_LIBRARY_PATH
