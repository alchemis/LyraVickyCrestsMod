PBStuff::POKEMONTOCREST[:WAILORD] = :LVCWAILCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCWAILCREST] = ItemData.new(:LVCWAILCREST, {
    name: "Wailord Crest",
    desc: "Increases Defenses based on current HP.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battler
    alias wailcrest_crestStats crestStats
    def crestStats
      wailcrest_crestStats
      case @crested
        when :WAILORD
            @defense = @defense + @hp * 0.5
            @spdef = @spdef + @hp * 0.5
      end
    end

    alias wailcrest_pbRecoverHP pbRecoverHP if !defined?(wailcrest_pbRecoverHP)
    def pbRecoverHP(amt, anim = false, hpbaranim = true, message: nil, hpamt: amt)
      anim = anim
      hpbaranim = hpbaranim
      message = nil if !defined?(message)
      ret = wailcrest_pbRecoverHP(amt, anim, hpbaranim, message: message, hpamt: amt)
      if @crested and @species == :WAILORD then
        self.pbUpdate() 
      end
      return ret
    end

    alias wailcrest_pbReduceHP pbReduceHP if !defined?(wailcrest_pbReduceHP)
    def pbReduceHP(amt, anim = false, emercheck = true, message: nil)
        message = nil if !defined?(message)
        ret = wailcrest_pbReduceHP(amt, anim, emercheck, message: message)
        if @crested and @species == :WAILORD then
          self.pbUpdate() 
        end
        return ret
    end

    alias wailcrest_pbEffectsOnDealingDamage pbEffectsOnDealingDamage if !defined?(wailcrest_pbEffectsOnDealingDamage)
    def pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent = false)
      if target.crested and target.species == :WAILORD then
        target.pbUpdate() 
      end
      return wailcrest_pbEffectsOnDealingDamage(move, user, target, damage, attackerNotPresent || false)
    end
end

