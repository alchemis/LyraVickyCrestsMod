PBStuff::POKEMONTOCREST[:SLAKING] = :LVCSLAKCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCSLAKCREST] = ItemData.new(:LVCSLAKCREST, {
    name: "Slaking Crest",
    desc: "Falls asleep when loafing around, healing 25% HP. Wakes up if not loafing around.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
  alias slakcrest_pbTryUseMove pbTryUseMove if !defined?(slakcrest_pbTryUseMove)
  def pbTryUseMove(choice, basemove, flags = { passedtrying: false, instructed: false })

    if self.ability == :TRUANT && !@effects[:Truant] && self.crested == :SLAKING && self.status == :SLEEP
      @battle.pbShowAbilityBox(self, item: true)
      self.pbCureStatus
      @battle.pbHideAbilityBox(self)
    end
    ret = slakcrest_pbTryUseMove(choice,basemove,flags)
    
    if self.ability == :TRUANT && @effects[:Truant] && self.crested == :SLAKING && !(self.status == :SLEEP)
        @battle.pbShowAbilityBox(self, item: true)
        self.pbSleep(rest: true, message: _INTL("{1} enjoyed a refreshing nap!", self.pbThis))
        self.pbRecoverHP(self.totalhp/4, true) if self.hp != self.totalhp
        @battle.pbHideAbilityBox(self)
    end

    return ret
  end
end