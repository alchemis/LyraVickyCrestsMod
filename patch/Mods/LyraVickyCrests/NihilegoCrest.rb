PBStuff::POKEMONTOCREST[:NIHILEGO] = :LVHNIHILCREST
#TODO +1 def in rain +2 in water fields

ModCacheInjection.hook(:items) {
  $cache.items[:LVHNIHILCREST] = ItemData.new(:LVHNIHILCREST, {
    name: "Nihilego Crest",
    desc: "Nihilego heals from foes' status damage. Opponent's status damage is increased when toxic poisoned.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battle
    def lvc_istherenihicrest?(mon)
      for battler in @battlers
        next if battler.isFainted?
        next if !battler.pbIsOpposing?(mon.index)
        return true if battler.crested == :NIHILEGO
      end
    end

    def lvc_nihiheal(amt,source)
      priority = setSpeedOrder
      for i in priority
        next if i.isFainted?
        if i.crested == :NIHILEGO && i.hp != i.totalhp && i.canHeal?
          pbShowAbilityBox(i,item:true)
          pbCommonAnimation("LeechSeed", i, source)
          pbDisplay(_INTL("{2} recovered some health!",source.pbThis,i.pbThis))
          i.absorbHP(amt.floor, source, :NihilegoCrest)
          pbHideAbilityBox(i)
        end
      end
    end
end


#lots of codeinjection

#leechseed
CodeInjector.insert_in_method_before(:PokeBattle_Battle,:__clauses__pbEndOfRoundPhase, "hploss = i.pbReduceHP(hploss, true, message: _INTL(\"{1}'s health is sapped by {2}!\", i.pbThis, getMoveName(:LEECHSEED)))",
 "hploss = (hploss * i.effects[:Toxic]).floor if i.status == :POISON && i.statusCount > 0 && lvc_istherenihicrest?(i)"
)
CodeInjector.insert_in_method(:PokeBattle_Battle,:__clauses__pbEndOfRoundPhase, "hploss = i.pbReduceHP(hploss, true, message: _INTL(\"{1}'s health is sapped by {2}!\", i.pbThis, getMoveName(:LEECHSEED)))",
"lvc_nihiheal(hploss/2,i) if hploss > 0")
#partially trapping moves
CodeInjector.replace_in_method(:PokeBattle_Battle,:__clauses__pbEndOfRoundPhase, "i.pbReduceHP((i.totalhp / binddiv).floor, true, message: _INTL(\"{1} is hurt by {2}!\", i.pbThis, movename))",
 "hploss = (i.totalhp / binddiv).floor
 hploss = (hploss * i.effects[:Toxic]).floor if i.status == :POISON && i.statusCount > 0 && lvc_istherenihicrest?(i)
 i.pbReduceHP(hploss, true, message: _INTL(\"{1} is hurt by {2}!\", i.pbThis, movename))
 lvc_nihiheal((i.totalhp / binddiv)/2,i) if hploss > 0
 "
)

#poison
CodeInjector.insert_in_method(:PokeBattle_Battle,:__clauses__pbEndOfRoundPhase, "hploss = (i.totalhp / 16.0).floor * i.effects[:Toxic] if i.statusCount > 0",
 "lvc_nihiheal(hploss/2,i) if hploss > 0"
)
#burn
CodeInjector.insert_in_method(:PokeBattle_Battle,:__clauses__pbEndOfRoundPhase, "hploss = (i.totalhp / 32.0).floor if i.ability == :HEATPROOF || @field.effect == :ICY",
 "lvc_nihiheal(hploss/2,i) if hploss > 0"
)
#petrification
CodeInjector.insert_in_method(:PokeBattle_Battle,:__clauses__pbEndOfRoundPhase, "hploss = i.pbReduceHP(hploss, true) if fairyAura.none?",
 "lvc_nihiheal(hploss/2,i) if hploss > 0"
)
