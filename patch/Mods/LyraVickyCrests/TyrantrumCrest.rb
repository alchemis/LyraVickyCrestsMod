PBStuff::POKEMONTOCREST[:TYRANTRUM] = :LVCTYRACREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCTYRACREST] = ItemData.new(:LVCTYRACREST, {
    name: "Tyrantrum Crest",
    desc: "Tyrantrum's Rock-Type and Rock moves become Fire, also doubles its Speed in harsh sunlight.", #and immune to status conditions
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

alias tyracrest_pbCrestMoveTypeChange pbCrestMoveTypeChange if !defined?(tyracrest_pbCrestMoveTypeChange)
def pbCrestMoveTypeChange(species, form, item, type)
    if species == :TYRANTRUM && item == :LVCTYRACREST && type == :ROCK then 
      return :FIRE

    end
    return tyracrest_pbCrestMoveTypeChange(species, form, item, type)
end

class PokeBattle_Battle

end

class PokeBattle_Battler
    alias tyracrest_crestStats crestStats if !defined?(tyracrest_crestStats)
    def crestStats
      tyracrest_crestStats
      case @crested
        when :TYRANTRUM
            @type1 = :FIRE
      end
    end
    alias tyracrest_pbSpeed pbSpeed if !defined?(tyracrest_pbSpeed)
    def pbSpeed()
      speed = tyracrest_pbSpeed
      if self.crested == :TYRANTRUM && @battle.pbWeather(nil) == :SUNNYDAY
        speed *= 2 #guaranteed to be a whole number so we dont have to .floor
      end
      return speed
    end
    
    # alias tyracrest_pbCanStatus? pbCanStatus? if !defined?(tyracrest_pbCanStatus?)
    # def pbCanStatus?(attacker, move, ignorestatus: false, showMessage: false)
    #   can_status = tyracrest_pbCanStatus?(attacker, move, ignorestatus: ignorestatus, showMessage: showMessage)
    #   if self.crested == :TYRANTRUM && @battle.pbWeather(nil) == :SUNNYDAY && can_status
    #     if showMessage
    #       @battle.pbShowAbilityBox(self, item: true)
    #       @battle.pbDisplay(_INTL("It doesn't affect\n{1}...", self.pbThis))
    #       @battle.pbHideAbilityBox(self)
    #     end
    #     can_status = false
    #   end
    #   return can_status
    # end
end