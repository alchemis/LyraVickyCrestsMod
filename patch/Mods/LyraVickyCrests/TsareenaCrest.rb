PBStuff::POKEMONTOCREST[:TSAREENA] = :LVCTSARCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCTSARCREST] = ItemData.new(:LVCTSARCREST, {
    name: "Tsareena Crest",
    desc: "Tsareena decreases the Speed of adjacent Pokemon on entry.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}
class PokeBattle_Battle
  alias tsarcrest_pbCrestEffects pbCrestEffects if !defined?(tsarcrest_pbCrestEffects)
  def pbCrestEffects(index, pokemon)
      tsarcrest_pbCrestEffects(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :TSAREENA
          pbDisplay(_INTL("Bow before the queen!"))
          for i in [battler.pbOpposing1, battler.pbOpposing2,battler.pbPartner]
            next unless i.passiveAbilityApplies?

            pbShowAbilityBox(battler, item: true)
            i.pbChangeStats(PBStats::SPEED, -1, battler, :Intimidate)
          end
          pbHideAbilityBox(battler)
      end
  end
end