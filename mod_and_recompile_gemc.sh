#adds the fcal hitprocess to GEMC, and then recompiles it
cp gemc_mod/fcal_hitprocess*  $GEMC/hitprocess/clas12/
cp gemc_mod/SConstruct $GEMC
cp gemc_mod/HitProcess_MapRegister.cc $GEMC/hitprocess/
cd $GEMC
scons -j 8
