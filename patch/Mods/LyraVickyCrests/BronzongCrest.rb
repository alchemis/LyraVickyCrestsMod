PBStuff::POKEMONTOCREST[:BRONZONG] = :LVCBRONZCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCBRONZCREST] = ItemData.new(:LVCBRONZCREST, {
    name: "Bronzong Crest",
    desc: "Bronzong raises a Trick Room for 3 turns on entry.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battle
  alias bronzcrest_pbCrestEntry pbCrestEntry if !defined?(bronzcrest_pbCrestEntry)
  def pbCrestEntry(index, pokemon)
    bronzcrest_pbCrestEntry(index, pokemon)
    battler = @battlers[index]
    case battler.crested
      when :BRONZONG
        pbShowAbilityBox(battler, item: true)
        pbAnimation(:TRICKROOM, battler, nil)
        if @state.effects[:TrickRoom] == 0
          pbDisplay(_INTL("{1} twisted the dimensions!", battler.pbThis))
          @state.effects[:TrickRoom] = 3
        else
          pbDisplay(_INTL("{1} extended the Trick Room!", battler.pbThis))
          @state.effects[:TrickRoom] += 3
        end
        pbHideAbilityBox(battler)
    end
  end
end