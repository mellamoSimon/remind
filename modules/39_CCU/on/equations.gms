*** |  (C) 2006-2020 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of REMIND and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  REMIND License Exception, version 1.0 (see LICENSE file).
*** |  Contact: remind@pik-potsdam.de
*** SOF ./modules/39_CCU/on/equations.gms

*** ---------------------------------------------------------
*** calculate CCU emissions (= CO2 demand of CCU technologies)
*** ---------------------------------------------------------

q39_emiCCU(t,regi,te)$(te_ccu39(te)).. 
  sum(teCCU2rlf(te,rlf),
*later, this variable could contain CCU for cement curing and other applications appart from synfuels
    vm_co2CCU(t,regi,"cco2","ccuco2short",te,rlf)
  )
  =e=
  sum(se2se_ccu39(enty,enty2,te), 
    p39_co2_dem(t,regi,enty,enty2,te) 
  * vm_prodSe(t,regi,enty,enty2,te)
  )
;

*' Calculate share of CCU flows that go to long-term applications
q39_emiCCUlong()..
vm_co2CCUlong(t,regi,enty,enty2,te,rlf) 
  =e=
  p39_CCUlongShare(t,regi)*vm_FeedstocksCarbon(ttot,regi,entySe,entyFe,emiMkt)
;

*' Balance CCU flows
q39_emiCCUlongShort()..
vm_co2CCU() 
  =e=
  vm_co2CCUshort() + vm_co2CCUlong();

*' Adjust the shares of synfuels in transport liquids.
*' This equation is only effective when CCU is switched on.
q39_shSynTrans(t,regi)..
    (
	sum(pe2se(entyPe,entySe,te)$seAgg2se("all_seliq",entySe), vm_prodSe(t,regi,entyPe,entySe,te))
	+ sum(se2se(entySe,entySe2,te)$seAgg2se("all_seliq",entySe2), vm_prodSe(t,regi,entySe,entySe2,te))
    ) * v39_shSynTrans(t,regi)
    =e=
    vm_prodSe(t,regi,"seh2","seliqsyn","MeOH")
;

*** share of synthetic gas in all SE gases
q39_shSynGas(t,regi)..
    (
	sum(pe2se(entyPe,entySe,te)$seAgg2se("all_sega",entySe), vm_prodSe(t,regi,entyPe,entySe,te))
	+ sum(se2se(entySe,entySe2,te)$seAgg2se("all_sega",entySe2), vm_prodSe(t,regi,entySe,entySe2,te))
    ) * v39_shSynGas(t,regi)
    =e=
    vm_prodSe(t,regi,"seh2","segasyn","h22ch4")
;


*** EOF ./modules/39_CCU/on/equations.gms
